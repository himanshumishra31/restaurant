require 'test_helper'

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  include TokenGenerator

  test "should get page for enter email for resetting password" do
    get new_password_path
    assert_response :success
  end

  test "should show error if email entered is not found " do
    post passwords_path, params: { email: 'sd23fafasd@gmail.com' }
    assert_redirected_to new_password_url
    assert_equal 'Email address Not found', flash[:danger]
  end

  test "should raise error if email is not confirmed" do
    user = User.first
    user.toggle!(:confirmed)
    post passwords_path, params: { email: user.email }
    assert_redirected_to login_url
    assert_equal 'Email id not verified. Please confirm email from the mail sent to your id.', flash[:danger]
  end

  test "should send email with valid value" do
    post passwords_path, params: { email: User.first.email }
    assert_redirected_to store_index_url
    assert_equal 'Email sent with password reset instructions', flash[:info]
  end

  test "should raise error if reset token is not valid" do
    get edit_password_path(User.first)
    assert_redirected_to store_index_path
    assert_equal "Reset Link has been already used. ", flash[:danger]
  end

  test "should get edit page if reset token is valid" do
    user = User.first
    token = generate_token
    user.update_column(:reset_password_token, token)
    get edit_password_path(user.reset_password_token)
    assert_response :success
  end

  test "should show error if reset link is expired" do
    user = User.first
    user.update_columns(reset_password_sent_at: 2.day.ago)
    patch password_path(user), params: { email: user.email }
    assert_redirected_to new_password_url
    assert_equal 'Password Reset link is expired now. Please request again for new link', flash[:danger]
  end

  test "should show errors if new entered password has errors" do
    user = User.first
    user.update_columns(reset_password_sent_at: 1.hour.ago)
    patch password_path(user), params: { user: { password: '', password_confirmation: '' }, email: user.email }
    assert_template :edit
  end

  test "should show errors if new entered password has validation errors" do
    user = User.first
    user.update_columns(reset_password_sent_at: 1.hour.ago)
    patch password_path(user), params: { user: { password: '12', password_confirmation: '123' }, email: user.email }
    assert_template :edit
  end

  test "should update password with valid values" do
    user = User.first
    user.update_columns(reset_password_sent_at: 1.hour.ago)
    patch password_path(user), params: { user: { password: '12345678', password_confirmation: '12345678' }, email: user.email }
    assert_redirected_to login_url
    assert_equal 'Password has been reset', flash[:success]
  end

end
