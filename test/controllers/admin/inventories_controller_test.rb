require 'test_helper'

class InventoriesControllerTest < ActionDispatch::IntegrationTest

  setup do
    post login_url, params: { email: User.find(23).email, password: '1234567' }
    assert_redirected_to store_index_url
  end

  test "should get index page" do
    get admin_inventories_path
    assert_response :success
  end

  test "should get edit inventory page" do
    get edit_admin_inventory_path(Inventory.first)
    assert_response :success
  end

  test "should show error if inventory is not found" do
    get edit_admin_inventory_path(0)
    assert_redirected_to admin_inventories_path
    assert_equal 'Inventory not found. Please try again', flash[:danger]
  end

  test "should update with valid values" do
    patch admin_inventory_path(Inventory.first), params: { inventory: { quantity: 1, comments_attributes: { "0"=>{ body: "add", user_id: users(:first).id}}}}
    assert_redirected_to admin_inventories_path(cookies[:current_location])
    assert_equal "Changes have been successfully saved", flash[:success]
  end

  test "should raise error with invalid values" do
    patch admin_inventory_path(Inventory.first), params: { inventory: { quantity: "-4", comments_attributes: { "0"=>{ body: "add", user_id: users(:first).id}}}}
    assert_redirected_to admin_inventories_path(cookies[:current_location])
    assert_equal 'Insufficent quantity', flash[:danger]
  end

  test "should render same page if values has some validation errors" do
    patch admin_inventory_path(Inventory.first), params: { inventory: { quantity: "sfd", comments_attributes: { "0"=>{ body: "", user_id: users(:first).id}}}}
    assert_template :edit
  end
end
