class CreateShippingTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :shipping_types do |t|
      t.string :name
      t.decimal :price
      t.integer :delivery_days

      t.timestamps
    end
  end
end
