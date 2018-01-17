class AlterTableInventory < ActiveRecord::Migration[5.1]
  def change
    remove_column :inventories, :ingredient_id
  end
end
