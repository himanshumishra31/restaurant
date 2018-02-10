require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  setup do
    @order = Order.new
  end

  test "should raise error without phone number " do
    assert_not @order.valid?
    assert_equal ["can't be blank"], @order.errors[:phone_number]
  end

  test "should raise error for an invalid phone number" do
    order = Order.new(phone_number: '965420')
    assert_not order.valid?
    assert_no_match /^([9,8,7])(\d{9})$/, order.phone_number
    assert_equal ["is invalid"], order.errors[:phone_number]
  end

  test "should raise error without pick up time" do
    assert_not @order.valid?
    assert_includes @order.errors[:pick_up], "can't be blank"
  end

  test "should raise error if preparation time is not given" do
    order = Order.new(pick_up: Time.current, branch_id: branches(:first).id)
    assert_not order.valid?
    assert_includes order.errors[:pick_up], "require half an hour to prepare order"
  end

  test "should raise error if past time is entered for pick up" do
    order = Order.new(pick_up: 1.day.ago, branch_id: branches(:first).id)
    assert_not order.valid?
    assert_includes order.errors[:pick_up], "already past this time. Please Enter a time in future"
  end

  test "should raise if time is not between branch timings" do
    order = Order.new(pick_up: branches(:first).opening_time - 30.minutes, branch_id: branches(:first).id)
    assert_not order.valid?
    assert_includes order.errors[:pick_up], "pick up a time between branch timings"
  end

  test "should raise error if user id is not given" do
    assert_not @order.valid?
    assert_equal ["must exist"], @order.errors[:user]
  end

  test "should raise error if cart id is not given" do
    assert_not @order.valid?
    assert_equal ["must exist"], @order.errors[:cart]
  end

  test "should raise error if branch id is not given" do
    assert_not @order.valid?
    assert_equal ["must exist"], @order.errors[:branch]
  end

  test "should give errors if wrong branch id is provided" do
    order = Order.new(branch_id: 1)
    assert_not order.valid?
    assert_equal ["must exist"], order.errors[:branch]
  end

  test "should give errors if wrong user id is provided" do
    order = Order.new(user_id: 1)
    assert_not order.valid?
    assert_equal ["must exist"], order.errors[:user]
  end

  test "should give errors if wrong cart id is provided" do
    order = Order.new(cart_id: 1)
    assert_not order.valid?
    assert_equal ["must exist"], order.errors[:cart]
  end

  test "should have default ready status as false" do
    assert_not @order.valid?
    assert_not @order.ready
  end

  test "should have default picked status as false" do
    assert_not @order.valid?
    assert_not @order.picked
  end

  test "should save with valid credentials" do
    order = Order.new(pick_up: Time.current + 2.hour, phone_number: '9654208158', user_id: users(:first).id, branch_id: branches(:first).id, cart_id: carts(:first).id)
    assert order.valid?
    # assert_difference 'Order.count', 1 do
    #   order.save
    # end
  end

end
