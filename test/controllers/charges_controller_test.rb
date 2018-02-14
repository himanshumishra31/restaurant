require 'test_helper'

class ChargesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:first)
    post login_url, params: { email: @user.email, password: '123456' }
    assert_redirected_to store_index_url
    @order = orders(:first)
  end

  test "should get new payment page" do
    get new_charge_path(@order)
    assert_response :success
  end

  test "should show error if order is not found" do
    get new_charge_path(100)
    assert_redirected_to store_index_url
    assert_equal 'Order has not been found. Try again with new order', flash[:danger]
  end
end
