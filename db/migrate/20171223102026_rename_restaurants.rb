class RenameRestaurants < ActiveRecord::Migration[5.1]
  def change
    rename_table :restaurants, :branches
  end
end
