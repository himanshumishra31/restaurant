class Meal < ApplicationRecord

  # assosciations
  has_many :meal_items, dependent: :destroy
  has_many :ingredients, through: :meal_items

  # validatons
  validates :name, presence: true

  accepts_nested_attributes_for :meal_items, allow_destroy: true

end
