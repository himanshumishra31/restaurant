class AlterMeals < ActiveRecord::Migration[5.1]
  def change
    remove_column :meals, :image
    add_attachment :meals, :picture
  end
end
