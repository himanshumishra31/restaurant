class OrderMailer < ActionMailer::Base
  def confirmation_mail(order)
    @order = order
    mail(from: Rails.application.secrets.email_id, to: @order.user.email, subject: 'Registration Confirmation')
  end
end
