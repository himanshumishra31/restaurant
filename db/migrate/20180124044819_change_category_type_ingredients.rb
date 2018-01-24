class ChangeCategoryTypeIngredients < ActiveRecord::Migration[5.1]
  def change
    change_column :ingredients, :category, :string
  end
end
