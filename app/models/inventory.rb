class Inventory < ApplicationRecord
  # associations
  belongs_to :ingredient
  belongs_to :branch
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :comments

  # validations
  validates :branch_id, uniqueness: { scope: :ingredient_id }
  validates :quantity, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end
