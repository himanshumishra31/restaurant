class RenameColumnsUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :confirm_email, :confirm
    rename_column :users, :confirm_token, :confirmation_token
  end
end
