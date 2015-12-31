module Spree
  class Gateway::Pagseguro < Gateway
    def provider_class
      Spree::PagseguroProvider
    end

    def method_type
      'pagseguro'
    end

    def supports?(source)
      true
    end

    def auto_capture?
      false
    end

    def authorize(amount, source, gateway_options = {})
      transaction = PagSeguro::Transaction.find_by_code(source.transaction_id)

      if transaction
        ActiveMerchant::Billing::Response.new(true, 'PagSeguro Gateway: Realizado com sucesso', {}, :authorization => source.transaction_id)
      else
        ActiveMerchant::Billing::Response.new(false, 'PagSeguro Gateway: Realizado com falha', { :message => 'Pagamento com PagSeguro inconsistente, por favor verificar!' })
      end
    end
  end
end