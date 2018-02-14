require 'test_helper'

class Admin::IngredientsControllerTest < ActionDispatch::IntegrationTest

  setup do
    post login_url, params: { email: User.find(23).email, password: '1234567' }
    assert_redirected_to store_index_url
  end

  test "should get new ingredient page" do
    get new_admin_ingredient_path
    assert_response :success
  end

  test "should create ingredient with valid values" do
    post admin_ingredients_path, params: { ingredient: { name: 'Abcd', price: 50, category: 'veg' } }
    assert_redirected_to admin_ingredients_path
    assert_equal 'Ingredient has been successfully created', flash[:success]
  end

  test "should show error if ingredient validation fails" do
    post admin_ingredients_path, params: { ingredient: { name: '' } }
    assert_template :new
  end

  test "should open index page" do
    get admin_ingredients_path
    assert_response :success
  end

  test "should open edit page" do
    get edit_admin_ingredient_path(Ingredient.first)
    assert_response :success
  end

  test "should update ingredient with valid details" do
    patch admin_ingredient_path(Ingredient.first), params: { ingredient: { name: 'abcd '} }
    assert_redirected_to admin_ingredients_path
    assert_equal "Changes have been successfully saved", flash[:success]
  end

  test "should show errors if value is not valid" do
    patch admin_ingredient_path(Ingredient.first), params: { ingredient: { name: ''} }
    assert_template :edit
  end

  test "should delete destroy successfully" do
    delete admin_ingredient_path(Ingredient.first)
    assert_redirected_to admin_ingredients_path
    assert_equal 'Ingredient has been successfully destroyed', flash[:success]
  end

  test "should show error if ingredient is not found" do
    delete admin_ingredient_path(0)
    assert_redirected_to admin_ingredients_path
    assert_equal 'Ingredient not found. Please try again', flash[:danger]
  end
end
