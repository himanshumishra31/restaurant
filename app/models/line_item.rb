class LineItem < ApplicationRecord

  #associations
  belongs_to :meal
  belongs_to :cart, counter_cache: :line_items_count

  # validations
  validates :meal_id, uniqueness: { scope: :cart_id, message: "duplicate entry" }

  def total_price
    if extra_ingredient.blank?
      meal.price * quantity
    else
      meal.price * quantity + Ingredient.find_by(name: extra_ingredient).price * quantity
    end
  end

  def ingredient_left(ingredient, branch)
    quantity_used = 0
    cart.line_items.each do |line_item|
      quantity_used += line_item.quantity  if line_item.extra_ingredient.eql? ingredient.name
      ingredient_used = line_item.meal.meal_items.find_by(ingredient_id: ingredient.id)
      quantity_used += ingredient_used.quantity * line_item.quantity if ingredient_used
    end
    branch.inventories.find_by(ingredient_id: ingredient.id).quantity - quantity_used >= quantity
  end

  def sufficient_stock(branch)
    meal.meal_items.each do |meal_item|
      ingredient_quantity_required = meal_item.quantity
      @ingredient_quantity_used = 0
      cart.line_items.each do |line_item|
        ingredient_used(line_item, meal_item)
      end
      branch_ingredient_quantity = branch.inventories.find_by(ingredient_id: meal_item.ingredient_id).quantity
      return false if ingredient_quantity_required > branch_ingredient_quantity - @ingredient_quantity_used
    end
    true
  end

  def ingredient_used(line_item, meal_item)
    ingredient = line_item.meal.meal_items.find_by(ingredient_id: meal_item.ingredient_id)
    @ingredient_quantity_used += line_item.quantity * ingredient.quantity if ingredient
    if line_item.extra_ingredient.eql? Ingredient.find_by(id: meal_item.ingredient_id).name
      @ingredient_quantity_used += line_item.quantity
    end
  end

end
