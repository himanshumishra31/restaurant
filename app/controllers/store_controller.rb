class StoreController < ApplicationController
  before_action :set_session_branch, only: [:index]
  before_action :set_branch, only: [:index]
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
end
