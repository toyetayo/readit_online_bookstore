class UserProductReview < ApplicationRecord
  belongs_to :user
  belongs_to :product_review
end
