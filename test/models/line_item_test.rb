require 'test_helper'

class LineItemTest < ActiveSupport::TestCase

  setup do
    @line_item = LineItem.new
  end

  test "should raise error if meal id is not given" do
    assert_not @line_item.valid?
    assert_equal ["must exist"], @line_item.errors[:meal]
  end

  test "should raise error if cart id is not given" do
    assert_not @line_item.valid?
    assert_equal ["must exist"], @line_item.errors[:cart]
  end

  test "should have default quantity as 0" do
    assert_not @line_item.valid?
    assert_equal @line_item.quantity, 0
  end

  test "should raise errors if meal_id and cart id is not unique" do
    line_item = LineItem.new(meal_id: line_items(:first).meal_id, cart_id: line_items(:first).cart_id)
    assert_not line_item.valid?
    assert_equal ["has already been taken"], line_item.errors[:meal_id]
  end

  test "should save with valid credentials" do
    line_item = LineItem.new(meal_id: meals(:second).id, cart_id: carts(:first).id)
    assert line_item.valid?
    assert_difference "LineItem.count", 1 do
      line_item.save
    end
  end
end
