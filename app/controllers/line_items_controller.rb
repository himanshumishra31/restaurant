class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart
  before_action :set_line_item, only: [:reduce_quantity, :destroy]
  before_action :set_available_meal_array
  before_action :update_stock, only: [:destroy, :reduce_quantity]

  def create
    meal = Meal.find(params[:meal_id])
    @line_item = @cart.add_meal(meal)
    check_remaining_stock
    respond_to do |format|
      if @line_item.save
        format.js { @available_meals = @available_meals_id }
        format.html { redirect_with_flash("success", "line_item_added", store_index_url(@cart)) }
      else
        format.html { redirect_to store_index_url }
      end
    end
  end

  def destroy
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_with_flash("success", "line_item_destroyed", @line_item.cart) }
      format.js { @available_meals = @available_meals_id }
    end
  end

  def reduce_quantity
    @line_item.update_attributes(quantity: @line_item.quantity - 1)
    respond_to do |format|
      format.html { redirect_with_flash("success", "line_item_destroyed", @line_item.cart) }
      format.js { @available_meals = @available_meals_id }
    end
  end

  private
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    def set_available_meal_id(available_meals, available_meals_id)
      available_meals.each do |meal|
        available_meals_id << meal.id
      end
    end
    def set_available_meal_array
      @available_meals_id = []
    end

    def update_stock
      check_remaining_stock
      set_available_meal_id(@available_veg_meals, @available_meals_id)
      set_available_meal_id(@available_non_veg_meals, @available_meals_id)
      @available_meals_id << @line_item.meal_id
    end

    def check_remaining_stock
      available_meals
      @cart.line_items.each do |line_item|
        stock_inventory = Inventory.find_by(branch_id: @branch.id, stock_id: line_item.meal_id)
        if stock_inventory.quantity.eql? line_item.quantity
          meal = Meal.find_by(id: line_item.meal_id)
          if @available_veg_meals.delete(meal)
          else
            @available_non_veg_meals.delete(meal)
          end
        end
      end
      set_available_meal_id(@available_veg_meals, @available_meals_id)
      set_available_meal_id(@available_non_veg_meals, @available_meals_id)
    end
end
