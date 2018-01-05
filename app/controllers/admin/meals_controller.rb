class Admin::MealsController < Admin::BaseController
  before_action :set_meal, only: [:destroy, :edit, :update]


  def index
    @meals = Meal.all
  end

  def create
    @meal = Meal.new(permitted_params)
    stock_available = check_stocks
    if @meal.save && stock_available
      redirect_with_flash("success", "meal_created", admin_meals_path)
    else
      redirect_with_flash("danger", "stock_unavailable", admin_meals_path)
    end
  end

  def update
    if @meal.update(permitted_params)
      redirect_with_flash("success", "successfully_saved", admin_meals_url)
    else
      render 'edit'
    end
  end

  def new
    @meal = Meal.new
  end

  def destroy
    if @meal.destroy
      redirect_with_flash("success", "successfully_destroyed", admin_meals_path)
    else
      redirect_with_flash("danger", "error_destroy", admin_meals_path)
    end
  end

  private
    def permitted_params
      params.require(:meal).permit(:name, :active, :picture, meal_items_attributes: [:id, :ingredient_id, :quantity, :_destroy])
    end

    def set_meal
      @meal = Meal.find_by(id: params[:id])
    end

    def check_stocks
      debugger
      if params[:meal][:active]
        @branch = Branch.find_by(name: session[:current_location])
        stock_available = true
        params[:meal][:meal_items_attributes].each do |attribute|
          @inventory = @branch.inventories.find_by(stock_id: params[:meal][:meal_items_attributes][attribute][:ingredient_id])
          stock_available &&= @inventory.quantity < params[:meal][:meal_items_attributes][attribute][:quantity]
        end
      end
      stock_available
    end
end
