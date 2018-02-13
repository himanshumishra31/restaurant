require 'test_helper'

class IngredientTest < ActiveSupport::TestCase

  setup do
    @ingredient = Ingredient.first
    @new_ingredient = Ingredient.new(name: 'paneer', price: 50, category: 'veg')
    @ingredient = Ingredient.new
  end

  test "should have valid fixture data #fixtures/users.yml" do
    assert ingredients(:first).valid?
  end

  test "should raise error if name is not present" do
    assert_not @ingredient.valid?
    assert_equal ["can't be blank"], @ingredient.errors[:name]
  end

  test "should raise error if price is not present" do
    assert_not @ingredient.valid?
    assert_equal ["can't be blank"], @ingredient.errors[:price]
  end

  test "should raise error if price is not a number" do
    ingredient = Ingredient.new(price: 'hello')
    assert_not ingredient.valid?
    assert_equal ["is not a number"], ingredient.errors[:price]
  end

  test "should raise error if name already exists" do
    ingredient = Ingredient.new(name: ingredients(:first).name)
    assert_not ingredient.valid?
    assert_equal ["has already been taken"], ingredient.errors[:name]
  end

  test "should raise error if price is negative" do
    ingredient = Ingredient.new(price: -2)
    assert_not ingredient.valid?
    assert_equal ["must be greater than 0"], ingredient.errors[:price]
  end

  test "should raise error if price is zero" do
    ingredient = Ingredient.new(price: 0)
    assert_not ingredient.valid?
    assert_equal ["must be greater than 0"], ingredient.errors[:price]
  end

  test "should raise errors if category is not checked" do
    assert_not @ingredient.valid?
    assert_equal ["is not included in the list"], @ingredient.errors[:category]
  end

  test "should have default value of extra_allowed false" do
    assert_not @ingredient.category
  end

  test "should save with valid values" do
    assert_difference 'Ingredient.count', 1 do
      @new_ingredient.save
    end
  end

  test "should update meal price if ingredient price is updated" do
    @ingredient.update_columns(price: 80)
    assert @ingredient.save
  end
end
