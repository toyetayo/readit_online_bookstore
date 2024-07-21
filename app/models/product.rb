class Product < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :name, :author, :number_in_stock, :price, :description, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[author created_at description id id_value name number_in_stock price updated_at
       user_id]
  end
end
