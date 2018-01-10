class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.time :pick_up
      t.string :phone_number
      t.references :cart, index: true
      t.references :user, index: true, foreign_key: true
      t.references :branch, index: true
      t.timestamps
    end
  end
end
