class MealItem < ApplicationRecord

  # associations
  belongs_to :ingredient
  belongs_to :meal

  # validations
  validates :quantity, presence: true

  def total_price
    quantity * ingredient.price
  end
end
