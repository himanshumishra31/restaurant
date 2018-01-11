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

  def affect_ingredient(action)
    @order.cart.line_items.each do |line_item|
      meal = Meal.find_by(id: line_item.meal_id)
      meal.meal_items.each do |meal_item|
        branch = @order.branch.inventories.find_by(ingredient_id: meal_item.ingredient_id)
        if action.eql? "reduce"
          branch.update_columns(quantity: branch.quantity - meal_item.quantity * line_item.quantity)
        elsif action.eql? "increase"
          branch.update_columns(quantity: branch.quantity + meal_item.quantity * line_item.quantity)
        end
      end
    end
  end
end
