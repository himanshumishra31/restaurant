class LineItem < ApplicationRecord

  #assosciations
  belongs_to :meal
  belongs_to :cart, counter_cache: :line_items_count

  # validations
  validates :meal_id, uniqueness: { scope: :cart_id, message: "duplicate entry" }

  def total_price
    if extra_ingredient.blank?
      meal.price * quantity
    else
      meal.price * quantity + Ingredient.find_by(name: extra_ingredient).price * quantity
    end
  end
end
