module Spree
  class PagseguroCheckout < ActiveRecord::Base
    validates_presence_of :transaction_id

    has_many :payments, as: :source

    def process!
      payments.pending.each do |payment|
        raise RuntimeError.new('Payment and Order not belongs to same transaction') unless payment.order.id === transaction.reference.to_i

        case
          when status_paid? then payment.complete!
          when status_cancelled?
            payment.failure
            payment.order.cancel!
        end
      end
    end

    private
    def transaction
      @transaction ||= PagSeguro::Transaction.find_by_code transaction_id
    end

    def status
      transaction.status
    end

    def status_paid?
      status.paid? || status.available?
    end

    def status_cancelled?
      status.cancelled? || status.refunded?
    end
  end
end
