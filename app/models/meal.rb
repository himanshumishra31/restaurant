class Meal < ApplicationRecord

  # associations
  has_many :meal_items, dependent: :destroy
  has_many :ingredients, through: :meal_items
  # FIX_ME_PG_2:- Try to use dependent: :destroy
  has_many :ratings
  # FIX_ME_PG_2:- Move styles to Constant. Also rename `picture` to `image`
  has_attached_file :picture, styles: { medium: "300x300>", thumb: "100x100>" }

  # validatons
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
  validates_attachment :picture, content_type: { content_type: PAPERCLIP_CONTENT_TYPE_REGEX }

  # FIX_ME_PG_2:- Rename to `check_for_valid_ingredient_quantity`. Should not this validation be present in MealItem model.
  validate :ingredient_quantity_valid?
  # FIX_ME_PG_2:- Rename to `check_for_atleast_one_ingredient`
  validate :atleast_one_ingredient?

  # callbacks
  after_commit :set_price, on: [:create, :update]

  accepts_nested_attributes_for :meal_items, allow_destroy: true

  # FIX_ME_PG_2:- Create 2 methods:- veg? and non_veg?. Also code can be optimized here.
  def isnonveg?
    meal_items.any? { |meal_item| Ingredient.find_by(id: meal_item.ingredient_id).category.eql? 'non_veg' }
  end

  # FIX_ME_PG_2:- Optimize the code. Also try to use association here.
  def set_price
    self.price = 0
    meal_items.each do |meal_item|
      self.price += meal_item.quantity * Ingredient.find_by(id: meal_item.ingredient_id).price
    end
    update_columns(price: ((ENV["PROFIT_PERCENT"].to_i + 100) * 0.01 * self.price))
  end

  private

    def atleast_one_ingredient?
      # FIX_ME_PG_2:- Move the errors to locale.
      errors.add(:meal_items, " atleast one must present") unless meal_items.present?
    end

    def ingredient_quantity_valid?
      errors.add(:meal_items, " quantity must be positive") if meal_items.any? { |meal| meal.quantity.to_i < 1 }
    end

end
