require 'test_helper'

class Admin::BaseControllerTest < ActionDispatch::IntegrationTest
  test "should give error if other than admin try to access this section" do
    post login_url, params: { email: User.second.email, password: '123456' }
    get admin_branches_url
    assert_redirected_to store_index_url
    assert_equal "Sorry, you don't have authority to access this section", flash[:danger]
  end
end
