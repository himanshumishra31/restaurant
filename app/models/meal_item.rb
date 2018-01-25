class MealItem < ApplicationRecord

  # associations
  belongs_to :ingredient
  belongs_to :meal

  # validations
  validates :quantity, presence: true

  def meal_item_price
    quantity * ingredient.price
  end
end
