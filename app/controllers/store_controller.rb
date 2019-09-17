class StoreController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_cart, only: [:index, :category]
  before_action :load_available_meals, only: [:index, :category]
  before_action :load_meals_by_category, only: [:index, :category]

  # FIX_ME_PG_2:- I don't think we need this before_action.

  # FIX_ME_PG_2:- Lets load meals here according to filter(veg/non-veg).

  def category
    output = render_to_string partial: "store/meals"
    render json: { output: output }
  end

  def switch_branch
    cookies[:current_location] = params[:branch]
    if @current_user && @current_user.admin?
      redirect_to admin_inventories_path
    else
      redirect_to store_index_path
    end
  end

  private

    def load_available_meals
      @available_meals = @branch.available_meals
    end

    def load_meals_by_category
      session[:category] = params["category"] || "both"
      if session[:category].eql? 'Veg'
        @meals = @available_meals.select { |meal| meal.veg? }
      elsif session[:category].eql? 'Non Veg'
        @meals = @available_meals.select { |meal| meal.non_veg? }
      else
        @meals = @available_meals
      end
    end
end
