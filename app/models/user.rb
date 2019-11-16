class User < ApplicationRecord
  VALID_RESET_PASSWORD_LINK_TIME = 2.hours.ago
  include TokenGenerator
  has_secure_password

  enum role: [:customer, :admin]

  #validations
  validates :name, :email, presence: true
  validates :email, uniqueness: true, format: { with: EMAIL_VALIDATION_REGEX }, allow_blank: true
  validates :password, length: { minimum: 6 }, allow_blank: true

  # callbacks
  before_create :set_confirmation_token
  after_create :send_email_confirmation_mail, unless: :admin?
  after_update :reset_password_token_to_nil
  after_create_commit :generate_slug

  # associations
  has_many :comments, -> { where(body: 'sub') }, dependent: :destroy
  has_many :orders, dependent: :destroy

  def activate_email
    update_columns(confirmed: true, confirmation_token: nil)
  end

  def set_reset_password_token
    update_columns(reset_password_token: generate_token, reset_password_sent_at: Time.current)
  end

  def send_password_reset_email
    UserMailer.reset_password(self).deliver_later
  end

  def reset_password_token_expired?
    reset_password_sent_at < VALID_RESET_PASSWORD_LINK_TIME
  end

  def generate_slug
    update_columns(slug: generate_token)
  end

  private
    def send_email_confirmation_mail
      UserMailer.verify_email(self).deliver_later
    end

    def set_confirmation_token
      self.confirmation_token = generate_token
    end

    def reset_password_token_to_nil
      update_attribute(:reset_password_token, nil)
    end
end
