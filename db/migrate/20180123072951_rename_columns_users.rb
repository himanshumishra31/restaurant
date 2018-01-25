class RenameColumnsUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :email_confirmed, :confirm
    rename_column :users, :confirm_token, :confirmation_token
  end
end
