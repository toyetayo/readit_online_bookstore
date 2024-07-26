# app/models/order.rb
class Order < ApplicationRecord
  belongs_to :user
  belongs_to :province
  belongs_to :shipping_type
  has_many :order_items, dependent: :destroy

  validates :user, presence: true
  validates :status, presence: true
  validates :subtotal, presence: true

  enum status: { pending: 'pending', paid: 'paid', shipped: 'shipped' }

  before_validation :set_defaults
  before_save :calculate_total_price

  def calculate_total_price
    return unless subtotal.present? && province.present?

    gst = subtotal * province.gst_rate
    pst = subtotal * province.pst_rate
    hst = subtotal * province.hst_rate
    qst = subtotal * province.qst_rate

    self.total_price = subtotal + gst + pst + hst + qst
  end

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
