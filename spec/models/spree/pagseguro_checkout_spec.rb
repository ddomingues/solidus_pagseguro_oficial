require 'spec_helper'

describe Spree::PagseguroCheckout do
  subject { described_class.new transaction_id: '1223' }

  ORDER_ID = 1
  STATUS_PAID = 3
  STATUS_CANCELLED = 7

  context '#process' do
    let(:transaction) { double('transaction').as_null_object }
    let(:status_paid) { PagSeguro::PaymentStatus.new STATUS_PAID}
    let(:status_cancelled) { PagSeguro::PaymentStatus.new STATUS_CANCELLED }
    let(:order) { double('order').as_null_object }
    let(:payment) { double('payment').as_null_object }

    before do
      allow(order).to receive(:id).and_return(ORDER_ID)

      allow(payment).to receive(:order).and_return(order)

      payments = [payment]
      allow(payments).to receive(:pending).and_return(payments)

      allow(subject).to receive(:payments).and_return(payments)
      allow(subject).to receive(:transaction).and_return(transaction)
    end

    context 'when valid' do
      before { allow(transaction).to receive(:reference).and_return(ORDER_ID) }

      it 'completes payment' do
        allow(transaction).to receive(:status).and_return(status_paid)

        expect(payment).to receive(:complete!)

        subject.process!
      end

      it 'voids payment' do
        allow(transaction).to receive(:status).and_return(status_cancelled)

        expect(payment).to receive(:failure)
        expect(order).to receive(:cancel!)

        subject.process!
      end
    end

    context 'when invalid' do
      it 'raises an error when id of the order is not the same in the reference transaction' do
        allow(transaction).to receive(:reference).and_return(2)

        expect {
          subject.process!
        }.to raise_error(RuntimeError)
      end
    end
  end
end
