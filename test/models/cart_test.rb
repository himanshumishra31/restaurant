require 'test_helper'

class CartTest < ActiveSupport::TestCase
  test "should have default line items count to 0" do
    cart = Cart.new
    assert cart.valid?
    assert_equal 0, cart.line_items_count
  end

  test "should save with valid credentials" do
    cart = Cart.new
    assert cart.valid?
    assert_difference "Cart.count", 1 do
      cart.save
    end
  end
end
# class Cart < ApplicationRecord
#   # associations
#   has_many :line_items, dependent: :destroy
#   has_many :meals, through: :line_items

#   def add_meal(meal)
#     line_items.find_or_initialize_by(meal_id: meal.id)
#   end

#   def total_price
#     line_items.sum(&:total_price)
#   end
# end
