require 'test_helper'

class CartTest < ActiveSupport::TestCase
  setup do
    @cart = Cart.new
  end

  test "should have default line items count to 0" do
    assert @cart.valid?
    assert_equal 0, @cart.line_items_count
  end

  test "should save with valid credentials" do
    assert @cart.valid?
    assert_difference "Cart.count", 1 do
      @cart.save
    end
  end
end
