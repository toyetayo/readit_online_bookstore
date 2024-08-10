class Product < ApplicationRecord
  paginates_per 20
  has_many :order_items, dependent: :destroy
  has_many :product_reviews, dependent: :destroy
  has_many :shopping_cart_items, dependent: :destroy
  has_many :product_categories, dependent: :destroy
  belongs_to :category
  has_one_attached :image

  validates :name, :author, :description, :price, :number_in_stock, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }

  scope :new_products, -> { where('created_at >= ?', 3.days.ago) }
  scope :recently_updated, -> { where('updated_at >= ?', 3.days.ago) }
  scope :on_sale, -> { where('price < ?', 20) } # Example condition

  def self.search_by_keyword(keyword)
    where('name LIKE ? OR description LIKE ?', "%#{keyword}%", "%#{keyword}%")
  end

  def self.search_by_category(keyword, category_id)
    where('(name LIKE ? OR description LIKE ?) AND category_id = ?', "%#{keyword}%",
          "%#{keyword}%", category_id)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[author created_at description id name number_in_stock price updated_at category_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[category]
  end

  # Virtual attribute to determine if a product is on sale
  def on_sale?
    price < 20 # Example condition: product is on sale if the price is less than 20
  end
end
