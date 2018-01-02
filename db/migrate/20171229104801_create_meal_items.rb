class CreateMealItems < ActiveRecord::Migration[5.1]
  def change
    create_table :meal_items do |t|
      t.belongs_to :meal, index: true
      t.belongs_to :ingredient, index: true
      t.integer :quantity
      t.timestamps
    end
  end
end
