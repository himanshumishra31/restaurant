class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:create]
  before_action :set_line_item, only: [:reduce_quantity, :destroy]


  def create
    meal = Meal.find(params[:meal_id])
    @line_item = @cart.add_meal(meal)
    respond_to do |format|
      if @line_item.save
        format.js
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
      format.js
    end
  end

  def reduce_quantity
    @line_item.update_attributes(quantity: @line_item.quantity - 1)
    respond_to do |format|
      format.html { redirect_with_flash("success", "line_item_destroyed", @line_item.cart) }
      format.js { @current_item = @line_item }
    end
  end

  private
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # def check_ingredient_availability
    #   debugger
    #   @cart = Cart.find_by(id: @line_item.cart_id)
    #   @line_items = @cart.line_items
    #   @line_items.each do |line_item|
    #     quantity = line_item.quantity
    #     @meal = Meal.find_by(id: line_item.meal_id)
    #     @meal.meal_items.each do |meal_item|
    #       debugger
    #       inventory = Inventory.find_by(branch_id: @branch.id, ingredient_id: meal_item.ingredient_id).quantity
    #     end
    #   end
    # end
end
