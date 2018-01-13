class Order < ApplicationRecord
  # assosciations
  belongs_to :cart
  belongs_to :user
  belongs_to :branch
  has_one :charge, dependent: :destroy

  # validations
  validates :phone_number, presence: true
  validates :phone_number, format: { with: /^([9,8,7])(\d{9})$/,  multiline: true }, allow_blank: true
  validates :pick_up, presence: true
  validate :valid_pick_up_time?, if: :pick_up?

  def valid_pick_up_time?
    unless pick_up.between?(branch.opening_time, branch.closing_time)
      errors.add(:pick_up, " should be between branch timings" )
    end
  end

  def sufficient_stock
    cart.line_items.each do |line_item|
      line_item.meal.meal_items.each do |meal_item|
        ingredient_required = meal_item.quantity * line_item.quantity
        branch_ingredient = branch.inventories.find_by(ingredient_id: meal_item.ingredient_id)
        return false if ingredient_required > branch_ingredient
      end
    end
    true
  end
end
