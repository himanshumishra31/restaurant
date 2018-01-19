class CreateRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :ratings do |t|
      t.decimal :value, precision: 2, scale: 1
      t.string :review
      t.references :user, index: true
      t.references :meal, index: true
      t.timestamps
    end
  end
end
