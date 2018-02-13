require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  include TokenGenerator

  setup do
    @user = User.first
    @new_user = { name: 'Himanshu', password: '1234567', password_confirmation: '1234567', email: 'himanshumish@gmail.com'}
  end

  test "should get signup page" do
    get signup_path
    assert_response :success
  end

  test "should create new user" do
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: @new_user }
    end
    assert_redirected_to store_index_url
    assert_equal 'Please Confirm Your email', flash[:success]
  end

  test "should not create user with invalid details" do
    @new_user[:name] = ""
    post signup_path, params: { user: @new_user }
    assert_template :new
  end

  test "should redirect to login url if confirmation token is nil" do
    get confirm_email_registration_url(@user)
    assert_redirected_to login_url
    assert_equal 'Your email has been already confirmed. Please log in.', flash[:danger]
  end

  test "should confirm email" do
    token = generate_token
    @user.update_columns(confirmation_token: token)
    get confirm_email_registration_path(@user.confirmation_token)
    assert_redirected_to login_url
    assert_equal "Your email has been confirmed. Please sign in to continue.", flash[:success]
  end
end

