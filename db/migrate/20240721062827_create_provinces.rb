class CreateProvinces < ActiveRecord::Migration[7.0]
  def change
    create_table :provinces, id: false do |t|
      t.string :id, primary_key: true
      t.string :name, null: false
      t.decimal :gst_rate, null: false, precision: 5, scale: 4
      t.decimal :pst_rate, null: false, precision: 5, scale: 4
      t.decimal :hst_rate, null: false, precision: 5, scale: 4
      t.decimal :qst_rate, null: false, precision: 5, scale: 4

      t.timestamps
    end
  end
end
