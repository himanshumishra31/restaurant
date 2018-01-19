class User < ApplicationRecord
  extend ConfirmationToken
  has_secure_password

  enum role: [:customer, :admin]

  #validations
  validates :name, :email, presence: true
  validates :email, uniqueness: true, format: { with: EMAIL_VALIDATION_REGEX }, allow_blank: true
  validates :password, length: { minimum: 6 }, allow_blank: true
  validates :password, presence: true

  # callbacks
  before_create :confirmation_token
  after_create :send_email_confirmation, unless: :admin?

  # associations
  has_many :comments, dependent: :destroy
  has_many :orders, dependent: :destroy

  def activate_email
    update_columns(email_confirmed: true, confirm_token: nil)
  end

  def create_reset_digest
    update_columns(reset_digest: User.set_confirmation_token, reset_password_sent_at: Time.current)
  end

  def send_password_reset_email
    UserMailer.reset_password(self).deliver_now
  end

  def password_reset_expired?
    reset_password_sent_at < 2.hours.ago
  end

  def remember
    update_attribute(:remember_digest, User.set_confirmation_token )
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget_digest
    update_attribute(:remember_digest, nil)
  end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def admin?
    role.eql? 'admin'
  end

  private
    def send_email_confirmation
      UserMailer.verify_email(self).deliver
    end

    def confirmation_token
      self.confirm_token = User.set_confirmation_token
    end
end
