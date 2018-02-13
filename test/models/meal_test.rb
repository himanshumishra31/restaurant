require 'test_helper'

class MealTest < ActiveSupport::TestCase
  setup do
    @new_meal = Meal.new(name: 'new meal')
    @meal = Meal.new
  end

  test "should raise error without a name" do
    assert_not @meal.valid?
    assert_equal ["can't be blank"], @meal.errors[:name]
  end

  test "should raise error if meal name exists" do
    meal = Meal.new(name: meals(:first).name)
    assert_not meal.valid?
    assert_equal ["has already been taken"], meal.errors[:name]
  end

  test "should raise error without a meal item" do
    assert_not @meal.valid?
    assert_equal ["atleast one must present"], @meal.errors[:meal_items]
  end

end
