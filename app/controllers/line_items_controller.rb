class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart
  before_action :set_line_item, only: [:reduce_quantity, :destroy]
  before_action :set_branch, only: [:create, :destroy, :reduce_quantity]

  def create
    @meal = Meal.find(params[:meal_id])
    @line_item = @cart.add_meal(@meal)
    respond_to do |format|
      if sufficient_stock && @line_item.save
        @line_item.increment!(:quantity)
        format.js { @status = true }
      else
        format.js { @status = false }
      end
    end
  end

  def destroy
    @line_item.destroy
    respond_to do |format|
      format.js { @status = true }
    end
  end

  def reduce_quantity
    @line_item.update_attributes(quantity: @line_item.quantity - 1)
    respond_to do |format|
      format.js { @status = true }
    end
  end

  private
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    def sufficient_stock
      @cart.line_items.each do |line_item|
        cart_meal = Meal.find_by(id: line_item.meal_id)
        cart_meal.meal_items.each do |meal_item|
          ingredient_used = meal_item.quantity * line_item.quantity
          branch_ingredient = @branch.inventories.find_by(ingredient_id: meal_item.ingredient_id).quantity
          ingredient_required = @meal.meal_items.find_by(ingredient_id: meal_item.ingredient_id)
          if ingredient_required
            ingredient_required_quantity = ingredient_required.quantity
            if ingredient_required_quantity > branch_ingredient - ingredient_used
              @cart.line_items.delete(@line_item) if @line_item.quantity.eql? 0
              return false
            end
          end
        end
      end
      true
    end

end
