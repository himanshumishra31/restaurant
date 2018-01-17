class CreateCharges < ActiveRecord::Migration[5.1]
  def change
    create_table :charges do |t|
      t.references :order, index: true
      t.integer :customer_id
      t.integer :amount
      t.integer :last4
      t.string :status
      t.timestamps
    end
  end
end
