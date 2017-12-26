class Admin::IngredientsController < Admin::BaseController
  before_action :set_ingredient, only: [:destroy, :edit, :update]

  def new
    @ingredient = Ingredient.new
  end

  def create
    debugger
    @ingredient = Ingredient.new(permitted_ingredient_params)
    if @ingredient.save
      flash_message("success", "ingredient_created")
      redirect_to admin_ingredients_url
    else
      render 'new'
    end
  end

  def index
    @ingredients = Ingredient.all
  end

  def update
    if @ingredient.update(permitted_ingredient_params)
      flash_message("success", "successfully_saved")
      redirect_to admin_ingredients_url
    else
      render 'edit'
    end
  end

  def destroy
    @ingredient.destroy
    redirect_to admin_ingredients_url
  end

  private
    def permitted_ingredient_params
      params.require(:ingredient).permit(:name, :price, :category, :extra_allowed)
    end

    def set_ingredient
      @ingredient = Ingredient.find_by(id: params[:id])
    end

end
