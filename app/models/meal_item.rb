class MealItem < ApplicationRecord

  # assosciations
  belongs_to :ingredient
  belongs_to :meal

  # validations
  validates :quantity, presence: true
  validates :ingredient_id, uniqueness: { scope: :meal_id }, allow_blank: true
end
