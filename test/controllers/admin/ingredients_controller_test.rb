require 'test_helper'

class Admin::IngredientsControllerTest < ActionDispatch::IntegrationTest

  test "should get new ingredient page" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    get new_admin_ingredient_path
    assert_response :success
  end

  test "should create ingredient with valid values" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    post admin_ingredients_path, params: { ingredient: { name: 'Abcd', price: 50, category: 'veg' } }
    assert_redirected_to admin_ingredients_path
    assert_equal 'Ingredient has been successfully created', flash[:success]
  end

  test "should show error if ingredient validation fails" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    post admin_ingredients_path, params: { ingredient: { name: '' } }
    assert_template :new
  end

  test "should open index page" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    get admin_ingredients_path
    assert_response :success
  end

  test "should open edit page" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    get edit_admin_ingredient_path(Ingredient.first)
    assert_response :success
  end

  test "should update ingredient with valid details" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    patch admin_ingredient_path(Ingredient.first), params: { ingredient: { name: 'abcd '} }
    assert_redirected_to admin_ingredients_path
    assert_equal "Changes have been successfully saved", flash[:success]
  end

  test "should show errors if value is not valid" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    patch admin_ingredient_path(Ingredient.first), params: { ingredient: { name: ''} }
    assert_template :edit
  end

  test "should delete destroy successfully" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    delete admin_ingredient_path(Ingredient.first)
    assert_redirected_to admin_ingredients_path
    assert_equal 'Ingredient has been successfully destroyed', flash[:success]
  end
end
