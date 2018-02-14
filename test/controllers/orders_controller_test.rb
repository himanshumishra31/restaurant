require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include TokenGenerator

  setup do
    @user = users(:first)
    post login_url, params: { email: @user.email, password: '123456' }
    assert_redirected_to store_index_url
  end

  test "should open new order page" do
    get new_user_order_path(@user)
    assert_response :success
  end

  test "should create order" do
    post user_orders_path(@user), params: { order: { pick_up: '17:00', phone_number: '9654208158', branch_id: 2, cart_id: 131 } }
    assert_equal 'Order is successfully placed. It will be cancelled after 24 hours', flash[:success]
  end

  test "should render same page if order is not valid" do
    post user_orders_path(@user), params: { order: { pick_up: '15:00', phone_number: '', branch_id: 2, cart_id: 131 } }
    assert_template :new
  end

  test "should cancel order" do
    order = orders(:first)
    delete user_order_path(order.user, order)
    assert_redirected_to myorders_users_url
    assert_equal "Order successfully cancelled", flash[:success]
  end

  test "should show error if order is not found" do
    delete user_order_path(orders(:first).user, 0)
    assert_redirected_to store_index_path
    assert_equal 'Order not found. Please try again later', flash[:danger]
  end

  test "should not cancel order if order is ready" do
    order = orders(:first)
    order.update_column(:pick_up, Time.current - 20.minutes)
    delete user_order_path(order.user, order)
    assert_redirected_to myorders_users_url
    assert_equal "Order is prepared now. Cannot cancel.", flash[:danger]
  end

  test "should not create order if cart ingredient is not sufficient in inventory" do
    order = orders(:first)
    order.cart.line_items.first.update_column(:quantity, 2)
    post user_orders_path(@user), params: { order: { pick_up: '15:00', phone_number: '9654208158', branch_id: 2, cart_id: 131 } }
    assert_redirected_to store_index_path
  end

  test "should get feedback form " do
    order = orders(:first)
    token = generate_token
    order.update_columns(feedback_digest: token, feedback_email_sent_at: Time.current)
    get feedback_order_path(order.feedback_digest)
    assert_response :success
  end

  test "should show error if feeback form link is expired" do
    order = orders(:first)
    order.update_columns(feedback_digest: generate_token, feedback_email_sent_at: 2.day.ago)
    get feedback_order_path(order.feedback_digest)
    assert_redirected_to store_index_path
    assert_equal 'feedback link has expired.', flash[:danger]
  end

  test "should get error if order is not found while accessing feedback form" do
    get feedback_order_path(generate_token)
    assert_redirected_to store_index_path
    assert_equal 'Order not found. Please try again later', flash[:danger]
  end

  test "should redirected to login page if user is not logged in while accessing feedback form " do
    delete logout_path
    order = orders(:first)
    token = generate_token
    order.update_columns(feedback_digest: token, feedback_email_sent_at: Time.current)
    get feedback_order_path(order.feedback_digest)
    assert_redirected_to login_path
    assert_equal 'Login first and then access the link to provide feedback', flash[:danger]
  end
end
