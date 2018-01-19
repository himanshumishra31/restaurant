class AddColumnsToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :ready, :boolean, default: false
    add_column :orders, :picked, :boolean, default: false
  end
end
