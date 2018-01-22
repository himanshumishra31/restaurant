class ChangeDefaultValueQuantityCart < ActiveRecord::Migration[5.1]
  def change
    change_column_default :line_items, :quantity, 0
  end
end
