class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart
  before_action :set_line_item, only: [:reduce_quantity, :destroy, :update]
  before_action :set_branch, only: [:create, :update]
  before_action :extra_ingredient, only: [:update]

  def create
    @meal = Meal.find(params[:meal_id])
    @line_item = @cart.add_meal(@meal)
    @status = (@line_item.sufficient_stock(@branch) && @line_item.save) ? @line_item.increment!(:quantity) : false
  end

  def destroy
    @status = @line_item.destroy
  end

  def reduce_quantity
    @status = @line_item.update_attributes(quantity: @line_item.quantity - 1)
  end

  def update
    ingredient = Ingredient.find_by(name: params[:line_item][:extra_ingredient])
    if @line_item.ingredient_left(ingredient, @branch)
      @line_item.update_columns(extra_ingredient: params[:line_item][:extra_ingredient])
      redirect_with_flash("success", "extra_ingredient_added", store_index_url)
    else
      redirect_with_flash("danger", "insufficient_stock", store_index_url)
    end
  end


  private
    def extra_ingredient
      redirect_with_flash("danger", "no_select", store_index_path) unless params[:line_item][:extra_ingredient].present?
    end

    def set_line_item
      @line_item = LineItem.find_by(id: params[:id])
    end
end
