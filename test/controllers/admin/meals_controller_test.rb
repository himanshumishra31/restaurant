require 'test_helper'

class Admin::MealsControllerTest < ActionDispatch::IntegrationTest

  test "should get new meal page" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    get new_admin_meal_path
    assert_response :success
  end

  test "should create meal with valid values" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    post admin_meals_path, params: { meal: { name: 'Abcd', active: "1", meal_items_attributes: { "1518433007158"=> { ingredient_id: ingredients(:first).id, quantity: 1 } } } }
    assert_redirected_to admin_meals_path
    assert_equal 'Meal has been successfully created', flash[:success]
  end

  test "should show error if meal validation fails" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    post admin_meals_path, params: { meal: { name: '' } }
    assert_template :new
  end

  test "should open index page" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    get admin_meals_path
    assert_response :success
  end

  test "should open edit page" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    get edit_admin_meal_path(Meal.first)
    assert_response :success
  end

  test "should update meal with valid details" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    patch admin_meal_path(Meal.first), params: { meal: { name: 'Abcd', active: "1", meal_items_attributes: { "1518433007158"=> { ingredient_id: ingredients(:first).id, quantity: 1 } } } }
    assert_redirected_to admin_meals_path
    assert_equal "Changes have been successfully saved", flash[:success]
  end

  test "should show errors if value is not valid" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    patch admin_meal_path(Meal.first), params: { meal: { name: ''} }
    assert_template :edit
  end

  test "should open comments page" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    get show_comments_admin_meal_url(Meal.first)
    assert_response :success
  end

  test "should update meal availability status" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    patch toggle_meal_status_admin_meal_path(Meal.first)
    assert_redirected_to admin_meals_path
    assert_equal 'Successfully updated meal status', flash[:success]
  end

  test "should delete destroy successfully" do
    post login_url, params: { email: User.third.email, password: '1234567' }
    delete admin_meal_path(Meal.first)
    assert_redirected_to admin_meals_path
    assert_equal 'Meal has been successfully destroyed', flash[:success]
  end
end
