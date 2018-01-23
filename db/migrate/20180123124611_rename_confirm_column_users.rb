class RenameConfirmColumnUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :confirm, :confirmed
  end
end
