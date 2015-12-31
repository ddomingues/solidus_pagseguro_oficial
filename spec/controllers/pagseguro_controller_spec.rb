require 'spec_helper'

module Spree
  describe PagseguroController do
    let(:address) { build(:address_brazil) }
    let(:order) { create(:order_with_line_items, bill_address: address, ship_address: address) }
    let(:user) {create(:user_with_addreses, bill_address: address, ship_address: address)}
    let(:payment_method) { create(:pagseguro_payment_method) }

    context '#init_transaction' do
      before { allow(controller).to receive(:current_order).and_return(order) }

      it 'init transaction case user is present' do
        allow(controller).to receive(:spree_current_user).and_return(user)

        spree_post :init_transaction, {payment_method_id: "#{payment_method.id}"}

        expect(response).to be_redirect
      end
    end

    context '#confirm' do
      context 'when current_order is nil' do
        before do
          allow(controller).to receive(:current_order).and_return(nil)
          allow(controller).to receive(:current_spree_user).and_return(nil)
        end

        it 'redirects to cart path' do
          spree_post :confirm, {transaction_id: '232'}

          is_expected.to redirect_to spree.cart_path
        end
      end
    end

    context '#notify' do
      before do
        allow(controller).to receive(:current_order).and_return(nil)
        allow(controller).to receive(:current_spree_user).and_return(nil)
      end

      it 'raise error when not inform notificationCode' do
        expect {
          spree_post :notify
        }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end
end

