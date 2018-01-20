class RemoveColumnUsers < ActiveRecord::Migration[5.1]
  def change
    remove_columns :users, :remember_digest, :verify_digest, :verify_email_sent_at
  end
end
