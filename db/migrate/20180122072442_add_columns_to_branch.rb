class AddColumnsToBranch < ActiveRecord::Migration[5.1]
  def change
    add_column :branches, :address, :string
    add_column :branches, :contact, :string
  end
end
