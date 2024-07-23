class Order < ApplicationRecord
  belongs_to :user
  belongs_to :province
  belongs_to :shipping_type
  has_many :order_items, dependent: :destroy

  validates :total_price, :status, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at id status total_price updated_at user_id receiver_name city province_id shipping_type_id]
  end

  # Define ransackable associations
  def self.ransackable_associations(auth_object = nil)
    %w[order_items user province shipping_type]
  end
end
