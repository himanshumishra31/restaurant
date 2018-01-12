class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart
  before_action :set_line_item, only: [:reduce_quantity, :destroy, :update]
  before_action :set_branch, only: [:create, :destroy, :reduce_quantity, :update]

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
    @status = true
  end

  def update
    if params[:line_item][:extra_ingredient]
      ingredient = Ingredient.find_by(name: params[:line_item][:extra_ingredient])
      if ingredient_left(ingredient)
        @line_item.update_columns(extra_ingredient: params[:line_item][:extra_ingredient])
        redirect_to store_index_url
      else
        redirect_with_flash("success", "insufficient_stock", store_index_url)
      end
    end
  end


  private
    def set_line_item
      @line_item = LineItem.find_by(id: params[:id])
    end

    def ingredient_left(ingredient)
      quantity_used = 0
      @cart.line_items.each do |line_item|
        quantity_used += line_item.quantity  if line_item.extra_ingredient.eql? ingredient.name
        cart_meal = line_item.meal
        ingredient_used = cart_meal.meal_items.find_by(ingredient_id: ingredient.id)
        quantity_used += ingredient_used.quantity * line_item.quantity if ingredient_used
      end
      if @branch.inventories.find_by(ingredient_id: ingredient.id).quantity - quantity_used > 0
        return true
      else
        return false
      end
    end

    def sufficient_stock
      @meal.meal_items.each do |meal_item|
        ingredient_quantity_required = meal_item.quantity
        ingredient_quantity_used = 0
        @cart.line_items.each do |line_item|
          cart_meal = line_item.meal
          ingredient = cart_meal.meal_items.find_by(ingredient_id: meal_item.ingredient_id)
          ingredient_quantity_used += line_item.quantity * ingredient.quantity if ingredient
          if line_item.extra_ingredient.eql? Ingredient.find_by(id: meal_item.ingredient_id).name
            ingredient_quantity_used += line_item.quantity
          end
        end
        branch_ingredient_quantity = @branch.inventories.find_by(ingredient_id: meal_item.ingredient_id).quantity
        return false if ingredient_quantity_required > branch_ingredient_quantity - ingredient_quantity_used
      end
      true
    end

end
