class Order < ApplicationRecord
  # assosciations
  belongs_to :cart
  belongs_to :user
  belongs_to :branch

  # validations
  validates :phone_number, format: { with: /^([9,8,7])(\d{9})$/,  multiline: true }

  def valid_pick_up_time?
  end
end
