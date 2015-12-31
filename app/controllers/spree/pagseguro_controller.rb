module Spree
  class PagseguroController < StoreController
    skip_before_action :verify_authenticity_token, only: :notify
    before_action :load_order, only: [:init_transaction, :confirm]
    around_action :lock_order, only: [:init_transaction, :confirm]

    def init_transaction
      begin
        response = provider.init_transaction!

        if response.errors.any?
          flash[:error] = Spree.t('flash.payment_with_pagseguro', reasons: response.errors.join("\n"))
          redirect_to checkout_state_path(@order.state)
        else
          redirect_to response.url
        end

      rescue SocketError
        flash[:error] = Spree.t('flash.connection_failed')
        redirect_to checkout_state_path(@order.state)
      end
    end

    def confirm
      pagseguro_checkout = Spree::PagseguroCheckout.create! transaction_id: transaction_id

      @order.payments.create!(
        {
          :source => pagseguro_checkout,
          :amount => @order.total,
          :payment_method => payment_method
        }
      )

      unless @order.next
        flash[:error] = @order.errors.full_messages.join("\n")
        redirect_to checkout_state_path(@order.state) and return
      end

      pagseguro_checkout.process!

      if @order.completed?
        session[:order_id] = nil
        flash.notice = Spree.t(:order_processed_successfully).html_safe
        redirect_to spree.order_path(@order)
      else
        redirect_to checkout_state_path(@order.state)
      end
    end

    def notify
      checkout_worker.perform notification_code

      render nothing: true, status: 200
    end

    private
    def notification_code
      params.require(:notificationCode)
    end

    def transaction_id
      params.require(:transaction_id)
    end

    def load_order
      @order = current_order
      redirect_to spree.cart_path and return unless @order
    end

    def payment_method
      Spree::PaymentMethod.find( params.require(:payment_method_id) )
    end

    def provider
      redirect_url = pagseguro_confirm_url(payment_method_id: params.require(:payment_method_id))
      payment_method.provider_class.new @order, spree_current_user, pagseguro_notify_url, redirect_url
    end

    def checkout_worker
      Spree::PagseguroCheckoutWorker.new
    end
  end
end
