class ChangeProvinceIdToString < ActiveRecord::Migration[7.0]
  def change
    # Change province_id in orders table to string
    change_column :orders, :province_id, :string

    # If there are other tables with province_id, change them too
    # change_column :another_table, :province_id, :string
  end
end
