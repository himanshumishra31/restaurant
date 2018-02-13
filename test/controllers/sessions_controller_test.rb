require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  test "should get login page" do
    get login_url
    assert_response 200
  end

  test "should not get login page if an user is already login" do
    post login_url, params: { email: User.first.email, password: '123456' }
    assert_redirected_to store_index_url
    get login_url
    assert_redirected_to store_index_url
    assert_equal "Already logged in. Please Log out to login from another account.", flash[:danger]
  end

  test "should not allow to login if email is not confirmed" do
    user = User.first
    user.toggle!(:confirmed)
    post login_url, params: { email: user.email, password: '123456' }
    assert_redirected_to store_index_url
    assert_equal "Please activate your account by following instructions in the confirmation email that you received", flash[:danger]
  end

  test "should not allow to login if password or email is wrong" do
    post login_url, params: {email: 'dgsdfsafs@gmail.com', password: '123456' }
    assert_redirected_to login_url
    assert_equal 'Invalid Email / Password', flash[:danger]
  end

  test "should login user" do
    post login_url, params: { email: User.first.email, password: '123456' }
    assert_redirected_to store_index_url
  end

  test "should remember user when remember me option is ticked" do
    post login_url, params: { email: User.first.email, password: '123456', remember_me: 'on' }
    assert_redirected_to store_index_url
  end

  test "should logout user" do
    post login_url, params: { email: User.first.email, password: '123456' }
    assert_redirected_to store_index_url
    delete logout_path
    assert_redirected_to store_index_url
  end
end
