class Cart < ApplicationRecord
  # associations
  has_many :line_items, dependent: :destroy
  has_many :meals, through: :line_items

  def add_meal(meal)
    line_items.find_or_initialize_by(meal_id: meal.id)
  end

  def total_price
    line_items.sum(&:total_price)
  end
end
