class Ingredient < ApplicationRecord

  # validation
  validates :name, :price, presence: true
  validate :validate_price, if: :price?
  validates :category, inclusion: [true, false]

  # assosciations
  has_many :meal_items, dependent: :destroy
  has_many :meals, through: :meal_items
  has_many :inventories, as: :stock, dependent: :destroy

  private
    def validate_price
      errors.add(:price, 'Should be positive') if price < 0
    end
end
