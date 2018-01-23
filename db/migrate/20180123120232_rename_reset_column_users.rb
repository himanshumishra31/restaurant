class RenameResetColumnUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :reset_digest, :reset_password_token
  end
end
