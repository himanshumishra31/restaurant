class MealItem < ApplicationRecord

  # associations
  belongs_to :ingredient
  belongs_to :meal

  # validations
  validates :quantity, presence: true

  def ingredient_price_in_meal
    quantity * ingredient.price
  end
end
