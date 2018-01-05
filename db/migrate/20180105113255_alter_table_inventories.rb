class AlterTableInventories < ActiveRecord::Migration[5.1]
  def change
    add_reference :inventories, :stock, polymorphic: true, index: true
  end
end
