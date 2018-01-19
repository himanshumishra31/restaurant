class Rating < ApplicationRecord
  # assosciations
  belongs_to :user
  belongs_to :meal

  # validations
  validates :value, :review, presence: true
end
