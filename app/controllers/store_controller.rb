class StoreController < ApplicationController
  include CurrentCart
  before_action :set_session_branch, only: [:index, :category]
  before_action :set_branch, only: [:index, :category]
  before_action :set_cart, only: [:index, :category]
  before_action :load_available_meals, only: [:index, :category]
  before_action :categorize_available_meals, only: [:index, :category]
  before_action :current_user

  def index
    session[:category] = params["category"] || "both"
  end

  def set_session_branch
    if params[:branch]
      cookies[:current_location] = params[:branch]
      session[:cart_id] = nil
    end
  end

  def category
    output = render_to_string partial: "store/meals"
    render json: { output: output }
  end

  private

    def load_available_meals
      @available_meals = @branch.available_meals
    end

    def categorize_available_meals
      @available_veg_meals = []
      @available_non_veg_meals = []
      @available_meals.each do |meal|
        if meal.isnonveg?
          @available_non_veg_meals << meal
        else
          @available_veg_meals << meal
        end
      end
    end
end
