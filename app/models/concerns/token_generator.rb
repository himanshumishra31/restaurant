module TokenGenerator
  extend ActiveSupport::Concern

  def generate_token
    SecureRandom.urlsafe_base64
  end
end
