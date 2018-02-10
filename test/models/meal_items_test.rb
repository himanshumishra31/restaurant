require 'test_helper'

class MealItemTest < ActiveSupport::TestCase

  setup do
    @meal_item = MealItem.new
  end

  test "should raise error if quantity is not present" do
    assert_not @meal_item.valid?
    assert_includes @meal_item.errors[:quantity], "can't be blank"
  end

  test "should raise error if quantity is not greater than zero" do
    meal_item = MealItem.new(quantity: -2)
    assert_not meal_item.valid?
    assert_includes meal_item.errors[:quantity], "must be greater than 0"
  end

  test "should raise error if ingredient id is not given" do
    assert_not @meal_item.valid?
    assert_equal ["must exist"], @meal_item.errors[:ingredient]
  end

  test "should raise error if meal id is not given" do
    assert_not @meal_item.valid?
    assert_equal ["must exist"], @meal_item.errors[:meal]
  end

  test "should save with valid credentials" do
    meal_item = MealItem.new(ingredient_id: ingredients(:first).id, meal_id: meals(:first).id, quantity: 1)
    assert meal_item.valid?
    assert_difference 'MealItem.count', 1 do
      meal_item.save
    end
  end
end
