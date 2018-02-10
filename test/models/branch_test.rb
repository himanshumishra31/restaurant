require 'test_helper'

class BranchTest < ActiveSupport::TestCase

  setup do
    @new_branch = Branch.new(name: 'north delhi', opening_time: '2', closing_time: '3', address: '24/A North campus', contact_number: '9654208158')
  end

  test "should have valid fixture data #fixtures/users.yml" do
    assert branches(:first).valid?
  end

  test "should raise error without a name" do
    branch = Branch.new
    assert_not branch.valid?
    assert_equal ["can't be blank"], branch.errors[:name]
  end

  test "should raise error without opening time" do
    branch = Branch.new
    assert_not branch.valid?
    assert_equal ["can't be blank"], branch.errors[:opening_time]
  end

  test "should raise error without closing time" do
    branch = Branch.new
    assert_not branch.valid?
    assert_equal ["can't be blank"], branch.errors[:closing_time]
  end

  test "should raise error without address" do
    branch = Branch.new
    assert_not branch.valid?
    assert_equal ["can't be blank"], branch.errors[:address]
  end

  test "should give error without contact number" do
    branch = Branch.new
    assert_not branch.valid?
    assert_equal ["can't be blank"], branch.errors[:contact_number]
  end

  test "should give error if branch name already exists" do
    branch = Branch.new(name: branches(:first).name)
    assert_not branch.valid?
    assert_equal ["has already been taken"], branch.errors[:name]
  end

  test "should give error if opening time is ahead of closing time" do
    branch = Branch.new(closing_time: '2', opening_time: '4')
    assert_not branch.valid?
    assert_equal ["should be before closing time"], branch.errors[:opening_time]
  end

  test "should save with valid values" do
    assert_difference 'Branch.count', 1 do
      @new_branch.save
    end
  end

  test "should raise error for an invalid contact number" do
    branch = Branch.new(contact_number: '965420')
    assert_not branch.valid?
    assert_no_match /^([9,8,7])(\d{9})$/, branch.contact_number
    assert branch.errors[:contact_number].any?
    assert_equal ["is invalid"], branch.errors[:contact_number]
  end
end
