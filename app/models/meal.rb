class Meal < ApplicationRecord

  IMAGE_STYLES = { medium: "300x300>", thumb: "100x100>" }

  # associations
  has_many :meal_items, dependent: :destroy
  has_many :ingredients, through: :meal_items
  has_many :ratings, dependent: :destroy
  has_attached_file :image, styles: IMAGE_STYLES

  # validatons
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
  validates_attachment :image, content_type: { content_type: PAPERCLIP_CONTENT_TYPE_REGEX }

  validate :check_for_atleast_one_ingredient

  # callbacks
  after_commit :set_price

  accepts_nested_attributes_for :meal_items, allow_destroy: true

  def non_veg?
    meal_items.includes(:ingredient).any? { |meal_item| meal_item.ingredient.in?(Ingredient.non_veg) }
  end

  def veg?
    meal_items.includes(:ingredient).all? { |meal_item| meal_item.ingredient.in?(Ingredient.veg) }
  end

  def set_price
    update_columns(price: ((ENV["PROFIT_PERCENT"].to_i + 100) * 0.01 * meal_items.sum(&:total_price)))
  end

  def toggle_status
    toggle!(:active)
  end

  private

    def check_for_atleast_one_ingredient
      errors.add(:meal_items) unless meal_items.present?
    end

    def check_for_valid_ingredient_quantity
      errors.add(:meal_items, error_message('quantity', :meal, :meal_items)) if meal_items.any? { |meal| meal.quantity.to_i < 1 }
    end
end
