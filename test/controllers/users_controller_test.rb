require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = User.first
    @new_user = { name: 'Himanshu', password: '1234567', password_confirmation: '1234567', email: 'himanshumish@gmail.com'}
    post login_url, params: { email: @user.email, password: '123456' }
    assert_redirected_to store_index_url
  end

  test "should get edit page" do
    get edit_user_path(@user)
    assert_response 200
  end

  test "should edit user" do
    patch user_path(@user), params: { user: { email: @user.email, password: '123456', password_confirmation: '123456' } }
    assert_redirected_to store_index_url
    assert_equal "Changes have been successfully saved", flash[:success]
  end

  test "should not edit user with invalid details" do
    patch user_path(@user), params: { user: { name: '', password: '123456', password_confirmation: '123456' } }
    assert_template :edit
  end

  test "should get orders list" do
    get myorders_users_path
    assert_response 200
  end
end
