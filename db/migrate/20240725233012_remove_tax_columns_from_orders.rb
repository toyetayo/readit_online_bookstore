class RemoveTaxColumnsFromOrders < ActiveRecord::Migration[7.1]
  def change
    remove_column :orders, :gst, :decimal
    remove_column :orders, :pst, :decimal
    remove_column :orders, :hst, :decimal
    remove_column :orders, :qst, :decimal
  end
end
