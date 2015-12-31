module Spree
  class PagseguroCheckoutWorker
    def perform(notification_code)
      transaction = PagSeguro::Transaction.find_by_notification_code( notification_code )

      if transaction.errors.empty?
        @pagseguroCheckout = Spree::PagseguroCheckout.find_by! transaction_id: transaction.code
        @pagseguroCheckout.process!
      else
        # logger.error transaction.errors
      end
    end
  end
end
