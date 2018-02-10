require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @user = users(:first)
    @new_user = User.new(name: 'himanshu', email: 'himanshumishra@gmail.com', password: '123456', password_confirmation: '123456' )
  end

  test "should have valid fixture data #fixtures/users.yml" do
    assert users(:first).valid?
  end

  test "should have unique email address" do
    user = User.new(email: @user.email)
    assert_not user.valid?
    assert_equal ["has already been taken"], user.errors[:email]
  end

  test "should raise error without a name" do
    user = User.new
    assert_not user.valid?
    assert user.errors[:name].any?
    assert_equal ["can't be blank"], user.errors[:name]
  end

  test "should raise error without an email" do
    user = User.new
    assert_not user.valid?
    assert user.errors[:email].any?
    assert_equal ["can't be blank"], user.errors[:email]
  end

  test "should raise error without a password" do
    user = User.new
    assert_not user.valid?
    assert user.errors[:password].any?
    assert_equal ["can't be blank"], user.errors[:password]
  end

  test "should raise error for an invalid email" do
    user = User.new(email: 'himansh@')
    assert_not user.valid?
    assert_no_match /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, user.email
    assert user.errors[:email].any?
    assert_equal ["is invalid"], user.errors[:email]
  end

  test "should raise error if password's length smaller than 6" do
    user = User.new(password: '12')
    assert_not user.valid?
    assert user.errors[:password].any?
    assert_equal ["is too short (minimum is 6 characters)"], user.errors[:password]
  end

  test "should raise if password_confirmation is not present" do
    user = User.new(password: '12', password_confirmation: '1234')
    assert_not user.valid?
    assert user.errors[:password_confirmation].any?
    assert_equal ["doesn't match Password"], user.errors[:password_confirmation]
  end

  test "should have customer role by default" do
    user = User.new
    assert_not user.valid?
    assert "customer", user.role
  end

  test "should have confirmed field set as false" do
    user = User.new
    assert_not user.valid?
    assert_not user.confirmed
  end

  test "should create user with valid details" do
    assert @new_user.valid?
  end

  test "should have 2 valid user roles" do
    assert_equal 2, User.roles.length
  end

  test "should give error if password length is greater than 72" do
    user = User.new(password: 'sdfsdsfsdfdsfsdfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfdsfsfsdfsdfsdfsdfsdfsfdsfsdfsfsdfsddfs')
    assert_not user.valid?
    assert_equal ["is too long (maximum is 72 characters)"], user.errors[:password]
  end
end
