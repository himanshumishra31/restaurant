class AddExtraIngredientsToLineItems < ActiveRecord::Migration[5.1]
  def change
    add_column :line_items, :extra_ingredient, :string
  end
end
