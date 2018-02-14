require 'test_helper'

class RatingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:first)
    post login_url, params: { email: @user.email, password: '123456' }
    assert_redirected_to store_index_url
  end

  test "rate meals feedback"  do
    order = orders(:first)
    put rate_meals_path, params: { ratings: [{ value: 4.0, review: "nice", meal_id: order.cart.line_items.first.meal.id }] }
    assert_redirected_to store_index_path
  end

  test "create new rating if meal is not rated" do
    put rate_meals_path, params: { ratings: [{ value: 4.0, review: "nice", meal_id: meals(:second).id}] }
    assert_redirected_to store_index_path
  end
end
