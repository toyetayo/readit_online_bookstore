class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :shopping_cart_items, dependent: :destroy
  has_many :product_reviews, dependent: :destroy
  belongs_to :province

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.ransackable_attributes(auth_object = nil)
    %w[address city created_at email first_name id last_name phone_number province_id updated_at zip]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[orders shopping_cart_items product_reviews province]
  end
end
