class StoreController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_session_branch, only: [:index, :category]
  # FIX_ME
  before_action :set_branch, only: [:index, :category]
  before_action :set_cart, only: [:index, :category]
  before_action :load_available_meals, only: [:index, :category]
  before_action :load_meals_by_category, only: [:index, :category]

  # FIX_ME_PG_2:- I don't think we need this before_action.

  # FIX_ME_PG_2:- Lets load meals here according to filter(veg/non-veg).

  def category
    output = render_to_string partial: "store/meals"
    render json: { output: output }
  end

  private

    def set_session_branch
      if params[:branch]
        cookies[:current_location] = params[:branch]
        session[:cart_id] = nil
      end
    end

    def load_available_meals
      @available_meals = @branch.available_meals
    end

    def load_meals_by_category
      session[:category] = params["category"] || "both"
      if session[:category].eql? 'veg'
        @meals = @available_meals.select { |meal| meal.veg? }
      elsif session[:category].eql? 'non_veg'
        @meals = @available_meals.select { |meal| meal.non_veg? }
      else
        @meals = @available_meals
      end
    end
end
