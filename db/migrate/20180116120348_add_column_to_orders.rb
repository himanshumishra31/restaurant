class AddColumnToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :feedback_digest, :string
    add_column :orders, :feedback_email_sent_at, :datetime
  end
end
