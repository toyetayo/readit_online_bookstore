class Category < ApplicationRecord
  has_many :product_categories
  has_many :products, through: :product_categories

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id id_value name updated_at]
  end
end
