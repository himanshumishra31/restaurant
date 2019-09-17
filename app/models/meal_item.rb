class MealItem < ApplicationRecord

  delegate :price, to: :ingredient

  # associations
  belongs_to :ingredient
  belongs_to :meal

  # validations
  validates :quantity, presence: true

  def total_price
    quantity * price
  end
end
