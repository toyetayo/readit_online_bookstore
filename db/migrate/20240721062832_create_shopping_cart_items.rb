class CreateShoppingCartItems < ActiveRecord::Migration[7.1]
  def change
    create_table :shopping_cart_items do |t|
      t.references :product, null: false, foreign_key: true
      t.decimal :price
      t.datetime :date_added
      t.references :user, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
