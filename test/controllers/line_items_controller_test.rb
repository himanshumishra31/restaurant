require 'test_helper'

class LineItemsControllerTest < ActionDispatch::IntegrationTest

  test "should create line item" do
    post line_items_path, params: { meal_id: meals(:first).id }, xhr: :js
    assert_response :success
  end

  test "should show error if meal is not found while creating" do
    post line_items_path, params: { meal_id: 2 }, xhr: :js
    assert_redirected_to store_index_url
    assert_equal 'Meal not found', flash[:danger]
  end

  test "should show error if line_item is not found" do
    delete line_item_path(2), xhr: :js
    assert_redirected_to store_index_url
    assert_equal 'Line Item not found.', flash[:danger]
  end

  test "should destroy line item" do
    delete line_item_path(line_items(:first)), xhr: :js
    assert_response :success
  end

  test "should reduce quantity by 1" do
    patch update_quantity_line_item_path(line_items(:first)), xhr: :js
    assert_response :success
  end

  test "should show error if extra ingredient is not sufficient" do
    patch line_item_path(line_items(:first)), params: { line_item: { extra_ingredient: 'cheese slice'} }, xhr: :js
    assert_redirected_to store_index_url
    assert_equal 'Sorry Ingredient is not left. Please try again after some time', flash[:danger]
  end

  test "should update extra ingredient if stock is sufficient" do
    inventory = inventories(:first)
    inventory.update_column(:quantity, 2)
    patch line_item_path(line_items(:first)), params: { line_item: { extra_ingredient: 'cheese slice'} }, xhr: :js
    assert_redirected_to store_index_url
    assert_equal 'Extra Ingredient Added', flash[:success]
  end

  test "should show error if extra ingredient value is not given" do
    patch line_item_path(line_items(:first)), params: { line_item: { extra_ingredient: ''} }, xhr: :js
    assert_redirected_to store_index_url
    assert_equal 'Please select any extra ingredient', flash[:danger]
  end


end
