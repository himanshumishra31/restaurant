class Meal < ApplicationRecord

  # assosciations
  has_many :meal_items, dependent: :destroy
  has_many :ingredients, through: :meal_items
  has_attached_file :picture, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/public/images/10.jpg"

  # validatons
  validates :name, presence: true
  validates_attachment :picture, content_type: { content_type: /\Aimage\/.*\z/ }

  # callbacks
  after_commit :set_price, on: [:create, :update]

  accepts_nested_attributes_for :meal_items, allow_destroy: true

  def set_price
    self.price = 0
    self.meal_items.each do |meal_item|
      self.price += meal_item.quantity * Ingredient.find_by(id: meal_item.ingredient_id).price
    end
    self.update_columns(price: ((ENV["PROFIT_PERCENT"].to_i + 100) * 0.01 * self.price))
  end
end
