class RemoveColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :str
  end
end
