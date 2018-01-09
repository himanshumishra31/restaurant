class LineItem < ApplicationRecord

  #assosciations
  belongs_to :meal
  belongs_to :cart, counter_cache: :line_items_count

  # validations
  validates :meal_id, uniqueness: { scope: :cart_id, message: "duplicate entry" }

  def total_price
    meal.price * quantity
  end
end
