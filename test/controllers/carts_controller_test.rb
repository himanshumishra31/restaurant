require 'test_helper'

class CartsControllerTest < ActionDispatch::IntegrationTest

  setup do
    post login_url, params: { email: User.first.email, password: '123456' }
    assert_redirected_to store_index_url
  end

  test "should destroy cart" do
    delete cart_path(carts(:first))
    assert_redirected_to store_index_url
  end
end
