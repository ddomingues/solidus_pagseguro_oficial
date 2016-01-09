require 'spec_helper'

module Spree
  describe PagseguroProvider do
    HOST = 'http://localhost:3000'

    context '#init_transaction' do
      let(:address) { build(:address_brazil) }
      let(:user) { create(:user) }
      let(:order) { create(:order_with_line_items, bill_address: address, ship_address: address, user: user) }

      subject { PagseguroProvider.new order, user, "#{HOST}/notify", "#{HOST}/confirm" }

      it 'responds success' do
        response = subject.init_transaction!

        expect(response.errors).to be_empty
      end
    end
  end
end

