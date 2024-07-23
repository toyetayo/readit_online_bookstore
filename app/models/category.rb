class Category < ApplicationRecord
  has_many :product_categories, dependent: :destroy
  has_many :products, through: :product_categories

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id name updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[product_categories products]
  end
end
