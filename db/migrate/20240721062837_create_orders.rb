class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :receiver_name
      t.string :address
      t.string :city
      t.integer :zip
      t.references :province, null: false, foreign_key: true
      t.references :shipping_type, null: false, foreign_key: true
      t.datetime :purchase_date
      t.string :status

      t.timestamps
    end
  end
end
