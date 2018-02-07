class Ingredient < ApplicationRecord


  VALID_CATEGORIES = { veg: 'Veg', non_veg: 'Non Veg' }

  # FIX_ME_PG_3:- This should be in locale and not a constant.
  ERROR_MESSAGE = "not a valid category"

  # validation
  validates :name, :price, presence: true
  validates_uniqueness_of :name, case_sensitive: false
  validate :validate_price, if: :price?
  validates :category, inclusion: { in: VALID_CATEGORIES.values, message: ERROR_MESSAGE }

  # associations
  has_many :meal_items, dependent: :destroy
  has_many :meals, through: :meal_items
  has_many :inventories, dependent: :destroy

  # callbacks
  after_create :set_inventory
  after_update :update_meal_price

  # scope :veg, -> { where(category: VALID_CATEGORIES[:veg] )}
  # scope :non_veg, -> { where(category: VALID_CATEGORIES[:non_veg] )}

  private
    def validate_price
      errors.add(:price) if price < 0
    end

    def set_inventory
      Branch.all.map { |branch| branch.inventories.build(ingredient_id: id, branch_id: branch.id).save }
    end

    def update_meal_price
      Meal.all.each(&:set_price)
    end
end
