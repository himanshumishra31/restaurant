module ConfirmationToken
  def set_confirmation_token
    SecureRandom.urlsafe_base64
  end
end
