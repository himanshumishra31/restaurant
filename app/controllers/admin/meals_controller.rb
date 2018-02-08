class Admin::MealsController < Admin::BaseController
  before_action :set_meal, only: [:destroy, :edit, :update, :show_comments]
  before_action :ingredient_exists?, only: [:update]

  def index
    @meals = Meal.includes(:meal_items, :ingredients)
  end

  def create
    @meal = Meal.new(permitted_params)
    if @meal.save
      redirect_with_flash("success", "meal_created", admin_meals_path)
    else
      render :new
    end
  end

  def update
    if @meal.update(permitted_params)
      redirect_with_flash("success", "successfully_saved", admin_meals_url)
    else
      render :edit
    end
  end

  def show_comments
    @comments = Rating.where(meal_id: @meal.id)
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
      params.require(:meal).permit(:name, :active, :image, meal_items_attributes: [:id, :ingredient_id, :quantity, :_destroy])
    end

    def set_meal
      @meal = Meal.find_by(id: params[:id])
      redirect_with_flash("danger", "not_found", admin_meals_path) unless @meal
    end

    def ingredient_exists?
      if (@meal.meal_items.count.eql? 1) && (params[:meal][:meal_items_attributes]["0"][:_destroy].eql? '1')
        redirect_with_flash("danger", "only_one_ingredient", admin_meals_path)
      end
    end
end
