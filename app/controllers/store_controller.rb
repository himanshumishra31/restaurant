class StoreController < ApplicationController
  include CurrentCart
  before_action :set_session_branch, only: [:index]
  before_action :set_branch, only: [:index]
  before_action :set_cart, only: [:index]
  before_action :available_meals, only: [:index]

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

  def available_meals
    @available_veg_meals = []
    @available_non_veg_meals = []
    Meal.all.each do |meal|
      if meal.meal_items.any? { |meal_item| Ingredient.find_by(id: meal_item.ingredient_id).category }
        @available_non_veg_meals << meal
      else
        @available_veg_meals << meal
      end
    end
  end
end
