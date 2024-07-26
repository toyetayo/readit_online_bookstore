class AddProductPriceAndTaxRatesToOrderItemsAndOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :order_items, :product_price, :decimal, precision: 10, scale: 2, null: false, default: 0

    add_column :orders, :gst_rate, :decimal, precision: 5, scale: 4, null: false, default: 0
    add_column :orders, :pst_rate, :decimal, precision: 5, scale: 4, null: false, default: 0
    add_column :orders, :hst_rate, :decimal, precision: 5, scale: 4, null: false, default: 0
    add_column :orders, :qst_rate, :decimal, precision: 5, scale: 4, null: false, default: 0
  end
end
