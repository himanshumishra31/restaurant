class OrderMailer < ApplicationMailer
  def confirmation_mail(order)
    @order = order
    mail(to: @order.user.email, subject: 'Order Confirmation')
  end

  def feedback_mail(order)
    @order = order
    mail(to: @order.user.email, subject: 'Registration Confirmation')
  end
end
