class MealItem < ApplicationRecord

  # associations
  belongs_to :ingredient
  belongs_to :meal

  # validations
  validates :quantity, presence: true

  # FIX_ME:- Lets rename to `def total_price`
  def ingredient_price_in_meal
    # FIX_ME:- Lets delegate the price to ingredient price.
    quantity * ingredient.price
  end
end
