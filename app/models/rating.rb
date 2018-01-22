class Rating < ApplicationRecord
  # associations
  belongs_to :user
  belongs_to :meal

  # validations
  validates :value, :review, presence: true
end
