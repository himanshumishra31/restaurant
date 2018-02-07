class Meal < ApplicationRecord

  IMAGE_STYLES = { medium: "300x300>", thumb: "100x100>" }

  # associations
  # FIX_ME:- Lets rename the model to MealIngredient
  has_many :meal_items, dependent: :destroy
  has_many :ingredients, through: :meal_items
  has_many :ratings, dependent: :destroy
  has_attached_file :image, styles: IMAGE_STYLES

  # validatons
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
  validates_attachment :image, content_type: { content_type: PAPERCLIP_CONTENT_TYPE_REGEX }

  validate :check_for_valid_ingredient_quantity
  validate :check_for_atleast_one_ingredient

  # FOX_ME_PG_3:- It should only be called when the price changes. Please check.
  # callbacks
  after_commit :set_price, on: [:create, :update]

  accepts_nested_attributes_for :meal_items, allow_destroy: true

  def non_veg?
    # FIX_ME_PG_3:- use scope ingredient veg/ nonveg scope here.
    meal_items.includes(:ingredient).any? { |meal_item| meal_item.ingredient.category.eql? 'non_veg' }
  end

  def veg?
    meal_items.includes(:ingredient).all? { |meal_item| meal_item.ingredient.category.eql? 'veg' }
  end

  def set_price
    update_columns(price: ((ENV["PROFIT_PERCENT"].to_i + 100) * 0.01 * meal_items.sum(&:ingredient_price_in_meal)))
  end

  private

    def check_for_atleast_one_ingredient
      errors.add(:meal_items) unless meal_items.present?
    end

    def check_for_valid_ingredient_quantity
      errors.add(:meal_items, I18n.t('quantity')) if meal_items.any? { |meal| meal.quantity.to_i < 1 }
    end

end


# class Meal
#   has_many :meal_ratings
#   has_many :ratings, through: :meal_ratings
# end

# class User 
#   has_many :meal_ratings
#   has_many :ratings, through: :meal_ratings
# end

# class Rating
#   belongs_to :user
#   belongs_to :meal
# end
