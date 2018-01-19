class Branch < ApplicationRecord
  # validations
  validates :name, :opening_time, :closing_time, presence: true
  validates_uniqueness_of :name, case_sensitive: false
  validate :validate_timings, if: (:opening_time? && :closing_time?)

  # associations
  has_many :inventories, dependent: :destroy
  has_many :ingredients, through: :inventories
  has_many :orders, dependent: :destroy

  # callbacks
  after_save :set_inventories, only: [:create]

  def validate_timings
    errors.add(:opening_time, "should be before closing time") if closing_time < opening_time
  end

  def available_meals
    available_meals = []
    Meal.all.each { |meal| available_meals << meal if sufficient_stock?(meal) }
    available_meals
  end

  def sufficient_stock?(meal)
    meal.meal_items.each do |meal_item|
      branch_ingredient_quantity = inventories.find_by(ingredient_id: meal_item.ingredient_id).quantity
      return false if branch_ingredient_quantity < meal_item.quantity
    end
    true
  end

  def set_inventories
    Ingredient.all.map { |ingredient| inventories.build(ingredient_id: ingredient.id).save }
  end
end
