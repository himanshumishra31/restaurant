class Admin::IngredientsController < Admin::BaseController
  before_action :set_ingredient, only: [:destroy, :edit, :update]
  after_action :set_inventory, only: [:create]
  after_action :update_meal_price, only: [:update]

  def new
    @ingredient = Ingredient.new
  end

  def create
    @ingredient = Ingredient.new(permitted_params)
    if @ingredient.save
      redirect_with_flash("success", "ingredient_created", admin_ingredients_url)
    else
      render 'new'
    end
  end

  def index
    @ingredients = Ingredient.all
  end

  def update
    if @ingredient.update(permitted_params)
      redirect_with_flash("success", "successfully_saved", admin_ingredients_url)
    else
      render 'edit'
    end
  end

  def destroy
    redirect_with_flash("success", "successfully_destroyed", admin_ingredients_url) if @ingredient.destroy
  end

  private
    def permitted_params
      params.require(:ingredient).permit(:name, :price, :category, :extra_allowed)
    end

    def set_ingredient
      @ingredient = Ingredient.find_by(id: params[:id])
    end

    def set_inventory
      Branch.all.map { |branch| branch.inventories.build(ingredient_id: @ingredient.id, branch_id: branch.id).save }
    end

    def update_meal_price
      Meal.all.each(&:set_price)
    end
end
