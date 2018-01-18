class Ingredient < ApplicationRecord

  # validation
  validates :name, :price, presence: true
  validate :validate_price, if: :price?
  validates :category, inclusion: [true, false]

  # assosciations
  has_many :meal_items, dependent: :destroy
  has_many :meals, through: :meal_items
  has_many :inventories, dependent: :destroy

  # callbacks
  after_save :set_inventory, only: [:create]
  after_save :update_meal_price, only: [:update]

  private
    def validate_price
      errors.add(:price, 'Should be positive') if price < 0
    end

    def set_inventory
      Branch.all.map { |branch| branch.inventories.build(ingredient_id: id, branch_id: branch.id).save }
    end

    def update_meal_price
      Meal.all.each(&:set_price)
    end
end
