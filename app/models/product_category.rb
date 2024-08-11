class ProductCategory < ApplicationRecord
  # Associations
  belongs_to :product
  belongs_to :category

  # Validations
  validates :product_id, presence: true
  validates :category_id, presence: true
  validates :product_id,
            uniqueness: { scope:   :category_id,
                          message: "has already been assigned to this category" }
end
