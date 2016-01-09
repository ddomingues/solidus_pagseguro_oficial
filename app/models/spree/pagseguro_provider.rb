class Spree::PagseguroProvider
  def initialize(order, user, notification_url, redirect_url)
    @order = order
    @user = user
    @notification_url = notification_url
    @redirect_url = redirect_url
  end

  def init_transaction!
    payment = PagSeguro::PaymentRequest.new
    payment.reference = @order.id
    payment.extra_amount = @order.adjustment_total
    build_items_to payment
    payment.shipping = PagSeguro::Shipping.new shipping_options
    payment.sender = sender
    payment.notification_url = @notification_url
    payment.redirect_url = @redirect_url
    payment.register
  end

  private
  def build_items_to(payment)
    @order.line_items.each do |item|
      payment.items << {
        id: item.product.id,
        description: item.product.name,
        amount: item.price,
        quantity: item.quantity,
        weight: item.product.weight.round
      }
    end
  end

  def sender
    {
      name: @order.bill_address.full_name,
      email: @order.email,
      cpf: @user.cpf,
      phone: {
        area_code: @order.bill_address.phone_area_code,
        number: @order.bill_address.phone_number
      }
    }
  end

  def shipping_options
    {
      type_name: @order.shipments.first.selected_shipping_rate.shipping_method.name.downcase,
      cost: @order.shipment_total,
      address: {
        street: @order.bill_address.address1,
        number: @order.bill_address.number,
        complement: @order.bill_address.address2,
        district: @order.bill_address.district,
        city: @order.bill_address.city.name,
        state: @order.bill_address.state.abbr,
        postal_code: @order.bill_address.zipcode
      }
    }
  end
end