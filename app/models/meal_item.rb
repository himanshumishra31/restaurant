class MealItem < ApplicationRecord

  # assosciations
  belongs_to :ingredient
  belongs_to :meal

  # validations
  validates :quantity, presence: true
end
