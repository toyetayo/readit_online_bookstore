class ChangeZipToPostalCodeInOrders < ActiveRecord::Migration[7.1]
  def change
    rename_column :orders, :zip, :postal_code
    change_column :orders, :postal_code, :string
  end
end
