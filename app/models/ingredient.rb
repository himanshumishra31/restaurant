class Ingredient < ApplicationRecord
  validates :name, :price, presence: true
  validate :price_should_be_positive, if: :price?
  validates :category, inclusion: [true, false]

  private
    def price_should_be_positive
      errors.add(:price, 'Should be positive') if price < 0
    end
end
