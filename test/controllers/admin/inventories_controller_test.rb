require 'test_helper'

class InventoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index page" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    get admin_inventories_path
    assert_response :success
  end

  test "should get edit inventory page" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    get edit_admin_inventory_path(Inventory.first)
    assert_response :success
  end

  test "should update with valid values" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    patch admin_inventory_path(Inventory.first), params: { inventory: { quantity: 1, comments_attributes: { "0"=>{ body: "add", user_id: users(:first).id}}}}
    assert_redirected_to admin_inventories_path(cookies[:current_location])
    assert_equal "Changes have been successfully saved", flash[:success]
  end

  test "should raise error with invalid values" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    patch admin_inventory_path(Inventory.first), params: { inventory: { quantity: "-4", comments_attributes: { "0"=>{ body: "add", user_id: users(:first).id}}}}
    assert_redirected_to admin_inventories_path(cookies[:current_location])
    assert_equal 'Insufficent quantity', flash[:danger]
  end

  test "should render same page if values has some validation errors" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    patch admin_inventory_path(Inventory.first), params: { inventory: { quantity: "sfd", comments_attributes: { "0"=>{ body: "", user_id: users(:first).id}}}}
    assert_template :edit
  end
end
