class Meal < ApplicationRecord

  # associations
  has_many :meal_items, dependent: :destroy
  has_many :ingredients, through: :meal_items
  has_many :ratings
  has_attached_file :picture, styles: { medium: "300x300>", thumb: "100x100>" }

  # validatons
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
  validates_attachment :picture, content_type: { content_type: PAPERCLIP_CONTENT_TYPE_REGEX }
  validate :ingredient_quantity_valid?
  validate :atleast_one_ingredient?

  # callbacks
  after_commit :set_price, on: [:create, :update]

  accepts_nested_attributes_for :meal_items, allow_destroy: true

  def isnonveg?
    meal_items.any? { |meal_item| Ingredient.find_by(id: meal_item.ingredient_id).category }
  end

  private

    def atleast_one_ingredient?
      errors.add(:meal_items, " atleast one must present") unless meal_items.present?
    end

    def ingredient_quantity_valid?
      errors.add(:meal_items, " quantity must be positive") if meal_items.any? { |meal| meal.quantity.to_i < 1 }
    end

    def set_price
      self.price = 0
      meal_items.each do |meal_item|
        self.price += meal_item.quantity * Ingredient.find_by(id: meal_item.ingredient_id).price
      end
      update_columns(price: ((ENV["PROFIT_PERCENT"].to_i + 100) * 0.01 * self.price))
    end
end
