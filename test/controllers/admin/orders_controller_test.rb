require 'test_helper'

class Admin::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    post login_url, params: { email: User.third.email, password: '1234567' }
  end

  test "should open orders page" do
    get admin_orders_path
    assert_response :success
  end

  test "should update new orders on page" do
    get update_orders_admin_orders_path
    assert_response :success
  end

  test "should toggle order ready status" do
    patch toggle_ready_status_admin_order_path(Order.first)
    assert_redirected_to admin_orders_path
    assert_equal 'Order status has been successfully updated', flash[:success]
  end

  test "should give error while updating pick up status if order is not ready yet" do
    patch toggle_pick_up_status_admin_order_path(Order.first)
    assert_redirected_to admin_orders_path
    assert_equal 'Order is not prepared yet', flash[:danger]
  end

  test "should update pick up status if order is ready" do
    order = Order.first
    order.toggle!(:ready)
    patch toggle_pick_up_status_admin_order_path(Order.first)
    assert_redirected_to admin_orders_path
    assert_equal 'Order status has been successfully updated', flash[:success]
  end
end
