class Admin::InventoriesController < Admin::BaseController
  before_action :set_session_branch, only: [:index, :edit, :update]
  before_action :set_branch, only: [:index, :edit, :update]
  before_action :set_inventory, only: [:edit, :update]
  before_action :set_inventories, only: [:index]
  before_action :check_quantity, only: [:update]

  def index
    session[:current_location] = params[:branch] if params[:branch]
  end

  def edit
    set_comments
  end

  def update
    if sufficient_stock? && @inventory.update(permitted_params)
      @inventory.increment!(:quantity, params[:inventory][:quantity].to_i)
      redirect_with_flash("success", "successfully_updated", admin_inventories_path(session[:current_location]))
    else
      redirect_with_flash("danger", "stock_unavailable", admin_inventories_path(session[:current_location]))
    end
  end

  private

    def sufficient_stock?
      return true unless @inventory.stock_type.eql? 'Meal'
      @meal = Meal.find_by(id: @inventory.stock_id)
      return false if @meal.meal_items.any? { |meal_item| check_stock(meal_item) }
      reduce_quantity
      true
    end

    def check_stock(meal_item)
      stock = @branch.inventories.find_by(ingredient_id: meal_item.ingredient_id).quantity
      stock < (params[:inventory][:quantity].to_i * meal_item.quantity)
    end

    def reduce_quantity
      @meal.meal_items.each do |meal_item|
        stock = @branch.inventories.find_by(ingredient_id: meal_item.ingredient_id)
        reduce_stock = params[:inventory][:quantity].to_i * meal_item.quantity
        stock.update_columns(quantity: stock.quantity - reduce_stock)
      end
    end

    def set_inventory
      @inventory = Inventory.find_by(id: params[:id])
    end

    def set_inventories
      @inventories = Inventory.where(branch: @branch)
    end

    def set_session_branch
      session[:current_location] = params[:branch] if params[:branch]
    end

    def permitted_params
      params.require(:inventory).permit(comments_attributes: [:body, :user_id])
    end

    def set_comments
      @comments = @inventory.comments.includes(:user).limit(ENV["COMMENT_LIMIT"]).order(created_at: :desc)
    end

    def check_quantity
      if @inventory.quantity + params[:inventory][:quantity].to_i < 0
        redirect_with_flash("danger", "invalid_quantity", admin_inventories_path(session[:current_location]))
      end
    end
end
