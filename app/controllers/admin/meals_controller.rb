class Admin::MealsController < Admin::BaseController
  before_action :set_meal, only: [:destroy, :edit, :update]
  after_action :set_inventories, only: [:create]
  after_action :set_branch, only: [:create]

  def index
    @meals = Meal.all
  end

  def create
    @meal = Meal.new(permitted_params)
    if @meal.save
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

    def set_inventories
      if params[:meal][:active].eql? "1"
        Branch.all.map { |branch| @meal.inventories.build(stock_id: @meal.id, branch_id: branch.id).save }
      else
        @meal.inventories.build(stock_id: @meal.id, branch_id: @branch.id).save
      end
    end
end
