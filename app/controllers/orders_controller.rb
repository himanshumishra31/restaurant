class OrdersController < ApplicationController
  include CurrentCart
  before_action :current_user, only: [:create, :new]
  before_action :set_branch, only: [:create, :new]
  before_action :set_cart, only: [:create, :new]

  def create
    @order = Order.new(permitted_params)
    if sufficient_stock
      if @order.save
        redirect_with_flash("success", "successfully_placed", new_charge_path)
      else
        render 'new'
      end
    else
      session[:cart_id] = nil
      redirect_with_flash("danger", "insufficient_stock", store_index_path)
    end
  end

  def new
    if @current_user
      @order = Order.new
    else
      redirect_with_flash("danger", "login", login_path)
    end
  end

  def destroy
    @order = Order.find_by(id: params[:id])
    if @order.pick_up - Time.current > 30
      @order.destroy
      affect_ingredient("increase")
      redirect_with_flash("success", "order_cancelled", myorders_url)
    else
      redirect_with_flash("danger", "time_up", myorders_url)
    end
  end

  def sufficient_stock
    Ingredient.all.each do |ingredient|
      quantity_used = 0
      branch_quantity = @branch.inventories.find_by(ingredient_id: ingredient.id).quantity
      @cart.line_items.each do |line_item|
        quantity_used += line_item.quantity if line_item.extra_ingredient.eql? ingredient.name
        cart_meal = Meal.find_by(id: line_item.meal_id)
        ingredient_used = cart_meal.meal_items.find_by(ingredient_id: ingredient.id)
        quantity_used += line_item.quantity * ingredient_used.quantity if ingredient_used
      end
      return false if branch_quantity < quantity_used
    end
    true
  end

  private
    def permitted_params
      params.require(:order).permit(:pick_up, :phone_number, :user_id, :branch_id, :cart_id)
    end
end
