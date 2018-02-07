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

  private
    # FIX_ME_PG_3:- Lets make a meal associations and use that to check the quantity.
    def sufficient_stock?(meal)
      meal.meal_items.all? { |meal_item| inventories.find_by(ingredient_id: meal_item.ingredient_id).quantity >= meal_item.quantity }
    end

    def validate_timings
      # FIX_ME_PG_3:- Add the message to the errors too. Check the difference in console.
      errors.add(:opening_time) if closing_time < opening_time
    end

    # FIX_ME_PG_3:- What will happen if inventory rollbacks.
    # Also, once branch is created with existing ingredient and thn later on a new ingredient is added later on, then how are we assigning it to the branch.
    # We need to think of some better solution here.
    def set_inventories
      Ingredient.all.map { |ingredient| inventories.build(ingredient_id: ingredient.id).save }
    end
end


# class Branch
#  has_many :branch_meals, # quantity, ratings, reviews.
#  has_many :meals, through: :branch_meals

#  scope :available_meals, -> { }
#  scope :unavailable_meals, -> { }
# end

# class BranchMeal
  # belongs_to :meal
  # belongs_to :branch
# end

# class Meal
  # has_many :branch_meal
  # has_many :branch, through: :branch_meal
# end

# class MealItem
# end
