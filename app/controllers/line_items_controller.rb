class LineItemsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_cart
  before_action :set_line_item, only: [:update_quantity, :destroy, :update]
  before_action :extra_ingredient, only: [:update]
  before_action :set_meal, only: [:create]
  before_action :check_stock, only: [:update]

  def create
    @line_item = @cart.add_meal(@meal)
    @status = (@line_item.sufficient_stock(@branch) && @line_item.save) ? @line_item.increment!(:quantity) : false
  end

  def destroy
    @status = @line_item.destroy
  end

  def update_quantity
    @status = @line_item.update_attributes(quantity: @line_item.quantity - 1)
  end

  def update
    @line_item.update_columns(extra_ingredient: params[:line_item][:extra_ingredient])
    redirect_with_flash("success", "extra_ingredient_added", store_index_url)
  end

  private

    def check_stock
      ingredient = Ingredient.find_by(name: params[:line_item][:extra_ingredient])
      unless @line_item.ingredient_left(ingredient, @branch)
        redirect_with_flash("danger", "insufficient_stock", store_index_url)
      end
    end

    def set_meal
      @meal = Meal.find_by(id: params[:meal_id])
      unless @meal
        redirect_with_flash("danger", "not_found", store_index_url)
      end
    end

    def extra_ingredient
      unless params[:line_item][:extra_ingredient].present?
        redirect_with_flash("danger", "no_select", store_index_path)
      end
    end

    def set_line_item
      @line_item = LineItem.find_by(id: params[:id])
      unless @line_item
        redirect_with_flash("danger", "not_found", store_index_url)
      end
    end
end
