class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :author, null: false
      t.text :description, null: false
      t.decimal :price, null: false, precision: 10, scale: 2
      t.integer :number_in_stock, null: false
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
