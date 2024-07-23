class AddForeignKeyConstraints < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :order_items, :orders if foreign_key_exists?(:order_items, :orders)
    remove_foreign_key :order_items, :products if foreign_key_exists?(:order_items, :products)
    remove_foreign_key :shopping_cart_items, :users if foreign_key_exists?(:shopping_cart_items, :users)
    remove_foreign_key :shopping_cart_items, :products if foreign_key_exists?(:shopping_cart_items, :products)
    remove_foreign_key :product_reviews, :users if foreign_key_exists?(:product_reviews, :users)
    remove_foreign_key :product_reviews, :products if foreign_key_exists?(:product_reviews, :products)
    remove_foreign_key :orders, :users if foreign_key_exists?(:orders, :users)

    add_foreign_key :order_items, :orders, on_delete: :cascade
    add_foreign_key :order_items, :products, on_delete: :cascade
    add_foreign_key :shopping_cart_items, :users, on_delete: :cascade
    add_foreign_key :shopping_cart_items, :products, on_delete: :cascade
    add_foreign_key :product_reviews, :users, on_delete: :cascade
    add_foreign_key :product_reviews, :products, on_delete: :cascade
    add_foreign_key :orders, :users, on_delete: :cascade
  end
end
