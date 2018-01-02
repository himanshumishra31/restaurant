class Admin::MealsController < Admin::BaseController
  before_action :set_meal, only: [:destroy, :edit, :update]
  before_action :save_image, only: [:create, :update]
  before_action :set_image_url, only: [:create, :update]
  after_action :set_price, only: [:create, :update]

  def index
    @meals = Meal.all
  end

  def create
    @meal = Meal.new(permitted_params)
    if @meal.save
      redirect_with_flash("success", "meal_created", admin_meals_path)
    else
      render 'new'
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
      params.require(:meal).permit(:name, :active,:image_url, meal_items_attributes: [:ingredient_id, :quantity])
    end

    def set_meal
      @meal = Meal.find_by(id: params[:id])
    end

    def set_price
      price = 0
      params[:meal][:meal_items_attributes].each do |attribute_id|
        price += Ingredient.find_by(id: params[:meal][:meal_items_attributes][attribute_id][:ingredient_id]).price.to_i * params[:meal][:meal_items_attributes][attribute_id][:quantity].to_i
      end
      @meal.update_attributes(price: price)
    end

    def set_image_url
      params[:meal][:image_url] = params[:meal][:image_url].original_filename
    end

    def save_image
      image = params[:meal][:image_url]
      if image.present?
        path = File.join Rails.root, 'public', 'images'
        FileUtils.mkdir_p(path) unless File.exist?(path)
        File.open(File.join(path, image.original_filename), 'wb') do |file|
          file.puts image.read
        end
      end
    end

    def save_product_images
      3.times do |index|
        image = params[:product]["image#{ index + 1 }"]
        if image.present?
          path = File.join Rails.root, 'public', 'images'
          FileUtils.mkdir_p(path) unless File.exist?(path)
          File.open(File.join(path, image.original_filename), 'wb') do |file|
            file.puts image.read
          end
        end
      end
    end

end
