class Order < ApplicationRecord
  belongs_to :user
  belongs_to :province
  belongs_to :shipping_type
  has_many :order_items, dependent: :destroy

  validates :user, presence: true
  validates :status, presence: true
  validates :subtotal, presence: true

  enum status: { pending: 'pending', paid: 'paid', shipped: 'shipped' }

  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: :all_blank

  before_validation :set_defaults

  def self.ransackable_associations(auth_object = nil)
    %w[order_items province user shipping_type]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[address city created_at id province_id purchase_date receiver_name shipping_type_id status subtotal total_price
       updated_at user_id zip]
  end

  private

  def set_defaults
    self.status ||= 'pending'
    self.total_price ||= 0
  end
end
