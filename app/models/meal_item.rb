class MealItem < ApplicationRecord

  delegate :price, to: :ingredient

  # associations
  belongs_to :ingredient
  belongs_to :meal

  # validations
  validates :quantity, presence: true
  validates :quantity, numericality: { greater_than: 0 }

  def total_price
    quantity * price
  end
end
