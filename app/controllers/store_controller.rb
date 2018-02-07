class StoreController < ApplicationController
  include CurrentCart
  # FIX_ME: No need for before action. Instead create a new action for updating the branch location. `def update_branch`
  before_action :set_session_branch, only: [:index, :category]
  before_action :set_branch, only: [:index, :category]
  before_action :set_cart, only: [:index, :category]

  # FIX_ME_PG_3:- No need for these actions.
  before_action :load_available_meals, only: [:index, :category]
  before_action :load_meals_by_category, only: [:index, :category]


  # def index
      # @meals = @branch.available_meals
      # case params[:category]
      # when 'veg' then @meals.veg_meals
      # when 'non_veg' then @meals.non_veg_meals
      # else @meals
      # end
  # end

  # FIX_ME:- Make this a private method.
  def set_session_branch
    if params[:branch]
      cookies[:current_location] = params[:branch]
      session[:cart_id] = nil
    end
  end

  # FIX_ME_PG_3:- I dont think we need this action anymore.
  def category
    output = render_to_string partial: "store/meals"
    render json: { output: output }
  end

  private

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
