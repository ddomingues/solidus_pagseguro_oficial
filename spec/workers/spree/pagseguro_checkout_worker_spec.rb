require 'spec_helper'

module Spree
  describe PagseguroCheckoutWorker do
    let(:transaction) { double('transaction') }
    let(:pagseguro_checkout) { double('pagseguro_checkout') }

    before do
      allow(PagSeguro::Transaction).to receive(:find_by_notification_code).with('123').and_return(transaction)
    end

    it 'process payment when transaction no contains error' do
      mock_errors(transaction)
      allow(transaction).to receive(:code).and_return('321')
      mock_find_with(pagseguro_checkout)

      expect(pagseguro_checkout).to receive(:process!)

      subject.perform('123')
    end

    it 'do not process payment when transaction contains error' do
      mock_errors(transaction, false)

      expect(pagseguro_checkout).to_not receive(:process!)

      subject.perform('123')
    end

    it 'raises error when not exists Spree::PagseguroCheckout for code transaction' do
      mock_errors(transaction)
      allow(transaction).to receive(:code).and_return('222')

      expect {
        subject.perform('123')
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    def mock_errors(transaction, errors_empty=true)
      allow(transaction).to receive_message_chain(:errors, :empty?).and_return(errors_empty)
    end

    def mock_find_with(pagseguro_checkout)
      allow(Spree::PagseguroCheckout).to receive(:find_by!).with(transaction_id: '321').and_return(pagseguro_checkout)
    end
  end
end
