require 'test_helper'

class InventoryTest < ActiveSupport::TestCase

  setup do
    @new_inventory = Inventory.new(branch_id: branches(:second).id, ingredient_id: ingredients(:second).id)
    @inventory = Inventory.new
  end

  test "should give error without branch" do
    assert_not @inventory.valid?
    assert_equal ["must exist"], @inventory.errors[:branch]
  end

  test "should give error without ingredient" do
    assert_not @inventory.valid?
    assert_equal ["must exist"], @inventory.errors[:ingredient]
  end

  test "should give error if quantity is negative" do
    inventory = Inventory.new(quantity: -2)
    assert_not inventory.valid?
    assert_equal ["must be greater than or equal to 0"], inventory.errors[:quantity]
  end

  test "should give error if branch and ingredient combination already exist" do
    inventory = Inventory.new(branch_id: inventories(:first).branch_id, ingredient_id: inventories(:first).ingredient_id)
    assert_not inventory.valid?
    assert_equal ["has already been taken"], inventory.errors[:branch_id]
  end

  test "should save with valid credentials" do
    assert_difference 'Inventory.count', 1 do
      @new_inventory.save
    end
  end
end
