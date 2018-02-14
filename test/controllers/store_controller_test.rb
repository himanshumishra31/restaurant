require 'test_helper'

class StoreControllerTest < ActionDispatch::IntegrationTest

  test "should get main page" do
    get store_index_path
    assert_response :success
  end

  test "should get main store page with only veg meals" do
    get store_index_path, params: { category: 'veg' }
    assert_response :success
  end

  test "should get main store page with only non veg meals" do
    get store_index_path, params: { category: 'non_veg' }
    assert_response :success
  end

  test "should switch branch if branch has been changed from dropdown" do
    get switch_branch_path, params: { branch: branches(:first) }
    assert_redirected_to store_index_path
  end

  test "should redirect to inventory if branch has been changed and admin is logged in" do
    post login_url, params: { email: User.find(23).email, password: '1234567' }
    assert_redirected_to store_index_url
    get switch_branch_path, params: { branch: branches(:first) }
    assert_redirected_to admin_inventories_path
  end

  test "should refresh main page" do
    get store_category_path
    assert_response :success
  end
end
