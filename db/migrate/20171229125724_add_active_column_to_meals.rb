class AddActiveColumnToMeals < ActiveRecord::Migration[5.1]
  def change
    add_column :meals, :active, :boolean
  end
end
