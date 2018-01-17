class Cart < ApplicationRecord
  # assosciations
  has_many :line_items, dependent: :destroy
  has_many :meals, through: :line_items

  def add_meal(meal)
    current_item = line_items.find_by(meal_id: meal.id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(meal_id: meal.id)
    end
    current_item
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end
end
