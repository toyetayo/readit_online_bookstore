# app/models/order.rb
class Order < ApplicationRecord
  belongs_to :user
  belongs_to :province
  belongs_to :shipping_type
  has_many :order_items
end
