class Branch < ApplicationRecord
  # validations
  validates :name, :opening_time, :closing_time, :contact_number, :address, presence: true
  validates_uniqueness_of :name, case_sensitive: false
  validate :validate_timings, if: (:opening_time? && :closing_time?)
  validates :contact_number, format: { with: PHONE_NUMBER_VALIDATION_REGEX,  multiline: true }, allow_blank: true

  # associations
  has_many :inventories, dependent: :destroy
  has_many :ingredients, through: :inventories
  has_many :orders, dependent: :destroy

  # callbacks
  after_create :set_inventories


  def available_meals
    Meal.includes(:meal_items).includes(:ratings).select { |meal| meal if sufficient_stock?(meal) && meal.active }
  end

  def change_default_branch
    Branch.find_by(default: true).update_column(:default, false)
    update_columns(default: true)
  end

  private
    def sufficient_stock?(meal)
      meal.meal_items.all? { |meal_item| inventories.find_by(ingredient_id: meal_item.ingredient_id).quantity >= meal_item.quantity }
    end

    def validate_timings
      errors.add(:opening_time, error_message('invalid', :branch, :opening_time)) if closing_time < opening_time
    end

    def set_inventories
      Ingredient.all.map { |ingredient| inventories.build(ingredient_id: ingredient.id).save }
    end
end
