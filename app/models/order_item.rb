class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :product, :quantity, :price, :product_price, presence: true

  before_validation :set_product_price

  private

  def set_product_price
    self.product_price = product.price if new_record?
  end
end
