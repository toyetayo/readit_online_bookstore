class CreateUserProductReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :user_product_reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product_review, null: false, foreign_key: true
      t.datetime :review_date
      t.integer :rating

      t.timestamps
    end
  end
end
