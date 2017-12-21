class CreateAdmin < ActiveRecord::Migration[5.1]
  def change
    create_table :admins do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.boolean :email_confirmed, default: true
      t.string :reset_digest
      t.datetime :resent_sent_at
      t.string :remember_digest
      t.timestamps
    end
  end
end
