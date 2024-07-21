class Product < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :name, :author, :number_in_stock, :price, :description, presence: true
end
