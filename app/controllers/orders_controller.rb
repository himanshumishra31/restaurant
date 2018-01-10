class OrdersController < ApplicationController
  include CurrentCart
  before_action :current_user, only: [:create]
  before_action :set_branch, only: [:create]
  before_action :set_cart, only: [:create]

  def create
    if sufficient_stock
    else
      session[:cart_id] = nil
      redirect_with_flash("danger", "insufficient_stock", store_index_path)
    end

  end

  def new
    if current_user
      @order = Order.new
    else
      redirect_with_flash("danger", "login", login_path)
    end
  end

  def sufficient_stock
    @cart.line_items.each do |line_item|
      cart_meal = Meal.find_id(id: line_item.meal_id)
      cart_meal.meal_items.each do |meal_item|
        ingredient_required = meal_item.quantity * line_item.quantity
        branch_ingredient = @branch.inventories.find_by(ingredient_id: meal_item.ingredient_id)
        if ingredient_required > branch_ingredient
          return false
        end
      end
    end
    true
  end
end
