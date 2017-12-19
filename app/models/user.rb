class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  validates :name,:email, presence: true
  validates :email, uniqueness: true, format: { with: Email_Validation_Regex }, allow_blank: true
  before_create :confirmation_token
  has_secure_password

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_mail
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  private
    def confirmation_token
      if self.confirm_token.blank?
        self.confirm_token = SecureRandom.urlsafe_base64.to_s
      end
    end

    def remember
      self.remember_token = User.new_token
      update_attribute(:remember_digest, User.digest(remember_token))
    end

    class << self
      def new_token
        SecureRandom.urlsafe_base64
      end

      def digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
      end
    end

end
