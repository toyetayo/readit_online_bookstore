class CreateUserProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :user_products do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.datetime :purchase_date
      t.integer :quantity

      t.timestamps
    end
  end
end
