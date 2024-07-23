class AddDefaultValueToQuantityInShoppingCartItems < ActiveRecord::Migration[6.1]
  def change
    change_column_default :shopping_cart_items, :quantity, 0
  end
end
