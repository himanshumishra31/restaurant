class ChangeCategoryColumnType < ActiveRecord::Migration[5.1]
  def change
    change_column :ingredients, :category, 'boolean USING CAST(category AS boolean)'
  end
end
