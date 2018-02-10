require 'test_helper'

class ChargeTest < ActiveSupport::TestCase
  # belongs_to :order

  # validates :customer_id, :status, :amount, :last4, presence: true
  setup do
    @new_charge = Charge.new
  end

  test "should raise error without customer id" do
    assert_not @new_charge.valid?
    assert_equal ["can't be blank"], @new_charge.errors[:customer_id]
  end

  test "should raise error without status" do
    assert_not @new_charge.valid?
    assert_equal ["can't be blank"], @new_charge.errors[:status]
  end

  test "should raise error without last four digits of card" do
    assert_not @new_charge.valid?
    assert_equal ["can't be blank"], @new_charge.errors[:last4]
  end

  test "should raise error without amount" do
    assert_not @new_charge.valid?
    assert_equal ["can't be blank"], @new_charge.errors[:amount]
  end

  test "should raise error without order id" do
    assert_not @new_charge.valid?
    assert_equal ["must exist"], @new_charge.errors[:order]
  end

  test "should save with valid credentials" do
    new_charge = Charge.new(order_id: orders(:first).id, customer_id: 0, status: 'succeeded', last4: '4242', amount: 110)
    assert new_charge.valid?
    assert_difference 'Charge.count', 1 do
      new_charge.save
    end
  end
end
