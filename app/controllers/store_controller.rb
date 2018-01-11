class StoreController < ApplicationController
  include CurrentCart
  before_action :set_session_branch, only: [:index, :category]
  before_action :set_branch, only: [:index, :category]
  before_action :set_cart, only: [:index, :category]
  before_action :available_meals, only: [:index, :category]

  def index
    if params["Only Veg"]
      session[:only_veg] = true
    else
      session[:only_veg] = false
    end
  end

  def set_session_branch
    if params[:branch]
      session[:current_location] = params[:branch]
      session[:cart_id] = nil
    end
  end

  def category
    output = render_to_string partial: "store/meals"
    render json: { output: output }
  end

  def available_meals
    @available_veg_meals = []
    @available_non_veg_meals = []
    Meal.all.each do |meal|
      if sufficient_stock?(meal)
        if meal.meal_items.any? { |meal_item| Ingredient.find_by(id: meal_item.ingredient_id).category }
          @available_non_veg_meals << meal
        else
          @available_veg_meals << meal
        end
      end
    end
  end

  def sufficient_stock?(meal)
    meal.meal_items.each do |meal_item|
      branch_ingredient_quantity = @branch.inventories.find_by(ingredient_id: meal_item.ingredient_id).quantity
      return false if branch_ingredient_quantity < meal_item.quantity
    end
    true
  end
end
