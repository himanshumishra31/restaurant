class AddIngredientIdInventory < ActiveRecord::Migration[5.1]
  def change
    add_reference :inventories, :ingredient
  end
end
