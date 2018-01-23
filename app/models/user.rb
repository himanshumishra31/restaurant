class User < ApplicationRecord
  VALID_LINK_TIME = 2.hours.ago
  include TokenGenerator
  has_secure_password

  enum role: [:customer, :admin]

  #validations
  validates :name, :email, presence: true
  validates :email, uniqueness: true, format: { with: EMAIL_VALIDATION_REGEX }, allow_blank: true
  validates :password, length: { minimum: 6 }, allow_blank: true
  validates :password, presence: true

  # callbacks
  before_create :set_confirmation_token
  after_create :send_email_confirmation_mail, unless: :admin?

  # associations
  has_many :comments, dependent: :destroy
  has_many :orders, dependent: :destroy

  def activate_email
    update_columns(confirmed: true, confirmation_token: nil)
  end

  def set_reset_password_token
    update_columns(reset_password_token: generate_token, reset_password_sent_at: Time.current)
  end

  def send_password_reset_email
    UserMailer.reset_password(self).deliver_now
  end

  def reset_password_token_expired?
    reset_password_sent_at < VALID_LINK_TIME
  end

  def admin?
    role.eql? 'admin'
  end

  private
    def send_email_confirmation_mail
      UserMailer.verify_email(self).deliver
    end

    def set_confirmation_token
      self.confirmation_token = generate_token
    end
end
