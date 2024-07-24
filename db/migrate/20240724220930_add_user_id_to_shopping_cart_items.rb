class AddUserIdToShoppingCartItems < ActiveRecord::Migration[6.0]
  def change
    add_column :shopping_cart_items, :user_id, :integer
    add_foreign_key :shopping_cart_items, :users
  end
end
