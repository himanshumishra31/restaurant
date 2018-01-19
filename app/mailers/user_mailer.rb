class UserMailer < ApplicationMailer
  def verify_email(user)
    @user = user
    mail(to: @user.email, subject: 'Registration Confirmation')
  end

  def reset_password(user)
    @user = user
    mail(to: @user.email, subject: 'Password Reset')
  end
end
