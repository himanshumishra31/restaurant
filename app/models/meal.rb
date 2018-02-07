class Meal < ApplicationRecord

  IMAGE_STYLES = { medium: "300x300>", thumb: "100x100>" }

  # associations
  has_many :meal_items, dependent: :destroy
  has_many :ingredients, through: :meal_items
  # FIX_ME_PG_2:- Try to use dependent: :destroy - done
  has_many :ratings, dependent: :destroy
  # FIX_ME_PG_2:- Move styles to Constant. Also rename `picture` to `image` - done
  has_attached_file :image, styles: IMAGE_STYLES

  # validatons
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
  validates_attachment :image, content_type: { content_type: PAPERCLIP_CONTENT_TYPE_REGEX }

  # FIX_ME_PG_2:- Rename to `check_for_valid_ingredient_quantity`. Should not this validation be present in MealItem model.
  # to discuss
  validate :check_for_valid_ingredient_quantity
  # FIX_ME_PG_2:- Rename to `check_for_atleast_one_ingredient` - done
  validate :check_for_atleast_one_ingredient

  # callbacks
  after_commit :set_price, on: [:create, :update]

  accepts_nested_attributes_for :meal_items, allow_destroy: true

  # FIX_ME_PG_2:- Create 2 methods:- veg? and non_veg?. Also code can be optimized here. -done
  def non_veg?
    meal_items.includes(:ingredient).any? { |meal_item| meal_item.ingredient.in?(Ingredient.non_veg) }
  end

  def veg?
    meal_items.includes(:ingredient).all? { |meal_item| meal_item.ingredient.in?(Ingredient.veg) }
  end

  # FIX_ME_PG_2:- Optimize the code. Also try to use association here. - done
  def set_price
    update_columns(price: ((ENV["PROFIT_PERCENT"].to_i + 100) * 0.01 * meal_items.sum(&:total_price)))
  end

  private

    def check_for_atleast_one_ingredient
      # FIX_ME_PG_2:- Move the errors to locale. -done
      errors.add(:meal_items) unless meal_items.present?
    end

    def check_for_valid_ingredient_quantity
      errors.add(:meal_items, I18n.t('quantity')) if meal_items.any? { |meal| meal.quantity.to_i < 1 }
    end

end
