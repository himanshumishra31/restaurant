class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :current_user

  def authorize
    redirect_with_flash("danger", "login_to_continue", login_url) unless current_user
  end

  def current_user
    @current_user ||= load_current_user
  end

  def load_current_user
    if (user_id = session[:user_id])
      @current_user = User.find_by(id: user_id)
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        session[:user_id] = user.id
        @current_user = user
      end
    end
  end

  def logout_user
    forget_user(@current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def remember_user(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget_user(user)
    user.forget_digest
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def redirect_with_flash(type, message_name, path = nil)
    flash[type] = t(message_name, scope: [:controller, params[:controller], params[:action], :flash, type])
    redirect_to path if path
  end

  def set_branch
    session[:current_location] = Branch.find_by(default_res: true).name unless session[:current_location]
    @branch = Branch.find_by(name: session[:current_location])
  end

  def available_meals
    @available_non_veg_meals = []
    @available_veg_meals = []
    Meal.all.each do |meal|
      check = true
      isnonveg = false
      meal.meal_items.each do |meal_item|
        if @branch.inventories.find_by(ingredient_id: meal_item.ingredient_id)
          check &&= @branch.inventories.find_by(ingredient_id: meal_item.ingredient_id).quantity >= meal_item.quantity
          isnonveg ||= Ingredient.find_by(id: meal_item.ingredient_id).category
        else
          check = false
        end
      end
      if check
        if isnonveg
          @available_non_veg_meals << meal
        else
          @available_veg_meals << meal
        end
      end
    end
  end
end
