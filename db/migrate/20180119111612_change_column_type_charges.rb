class ChangeColumnTypeCharges < ActiveRecord::Migration[5.1]
  def change
    change_column :charges, :amount, :float
  end
end
