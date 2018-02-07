class Inventory < ApplicationRecord
  # associations
  belongs_to :ingredient
  belongs_to :branch
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :comments

  # validations
  validates :branch_id, uniqueness: { scope: :ingredient_id }
  validates :quantity, presence: true
  validate :validate_quantity, if: :quantity?

  private
    def validate_quantity
      errors.add(:quantity) if quantity < 0
    end
end
