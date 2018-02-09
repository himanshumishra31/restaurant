class Ingredient < ApplicationRecord

  VALID_CATEGORIES = { veg: 'veg', non_veg: 'non_veg' }

  # validation
  validates :name, :price, presence: true
  validates_uniqueness_of :name, case_sensitive: false
  validates :price, numericality: { greater_than: 0 }
  validates :category, inclusion: { in: VALID_CATEGORIES.values }

  # associations
  has_many :meal_items, dependent: :destroy
  has_many :meals, through: :meal_items
  has_many :inventories, dependent: :destroy

  # callbacks
  after_create :set_inventory
  after_update :update_meal_price, unless: :price_changed?

  scope :veg, -> { where(category: VALID_CATEGORIES[:veg] )}
  scope :non_veg, -> { where(category: VALID_CATEGORIES[:non_veg] )}

  private
    def price_changed?
      price.eql? price_was
    end

    def set_inventory
      Branch.all.map { |branch| branch.inventories.build(ingredient_id: id, branch_id: branch.id).save }
    end

    def update_meal_price
      Meal.all.each(&:set_price)
    end
end
