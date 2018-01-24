module OrderHelper
  def order_payment_successful(order)
    order.charge && (order.charge.status.eql? 'succeeded')
  end
end
