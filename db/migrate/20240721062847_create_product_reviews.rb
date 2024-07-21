class CreateProductReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :product_reviews do |t|
      t.references :product, null: false, foreign_key: true
      t.text :review
      t.integer :rating
      t.datetime :review_date
      t.string :reviewer_name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
