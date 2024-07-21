class CreateProvinces < ActiveRecord::Migration[7.1]
  def change
    create_table :provinces, id: false do |t|
      t.string :id, primary_key: true
      t.string :name
      t.decimal :gst_rate
      t.decimal :pst_rate
      t.decimal :hst_rate
      t.decimal :qst_rate

      t.timestamps
    end
  end
end
