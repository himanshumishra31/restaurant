class AddDefaultPrice < ActiveRecord::Migration[5.1]
  def change
    change_column_default :meals, :price, 0
  end
end
