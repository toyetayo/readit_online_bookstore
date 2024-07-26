class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :product, presence: true
  validates :quantity, presence: true
  validates :price, presence: true

  def total_price
    quantity * price
  end
end
