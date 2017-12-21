class Admin < ApplicationRecord
  validates :name, :email, presence: true
  validates :password, length: { minimum: 6 }, allow_blank: true
  validates :email, uniqueness: true, format: { with: Email_Validation_Regex }, allow_blank: true
  has_secure_password
end
