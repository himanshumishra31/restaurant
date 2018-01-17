class AddColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :verify_digest, :string
    add_column :users, :verify_email_sent_at, :datetime
  end
end
