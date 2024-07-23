class ProductReview < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :product, dependent: :destroy

  validates :rating, :review, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[product_id user_id review rating review_date reviewer_name created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[product user]
  end
end
