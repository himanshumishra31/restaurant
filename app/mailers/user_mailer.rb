class UserMailer < ActionMailer::Base
  def registration_confirmation(user)
    @user = user
    mail(from: Rails.application.secrets.username, to: @user.email, subject: 'Registration Confirmation')
  end

  def password_reset(user)
    @user = user
    mail(from: Rails.application.secrets.username, to: @user.email, subject: 'Password Reset')
  end
end
