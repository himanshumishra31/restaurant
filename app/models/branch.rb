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
    available_meals = []
    Meal.includes(:meal_items).includes(:ratings).all.each { |meal| available_meals << meal if sufficient_stock?(meal) }
    available_meals
  end

  # FIX_ME_PG_2:- Make this private method. -done

  private
    def sufficient_stock?(meal)
      return meal.meal_items.all? { |meal_item| inventories.find_by(ingredient_id: meal_item.ingredient_id).quantity >= meal_item.quantity }
    end

    def validate_timings
      errors.add(:opening_time) if closing_time < opening_time
    end

    def set_inventories
      Ingredient.all.map { |ingredient| inventories.build(ingredient_id: ingredient.id).save }
    end
end
