class Order < ApplicationRecord
  belongs_to :user
  belongs_to :province
  has_many :order_items, dependent: :destroy

  validates :user, presence: true
  validates :status, presence: true
  validates :subtotal, presence: true

  before_validation :set_defaults

  private

  def set_defaults
    self.status ||= 'Pending'
    self.total_price ||= 0
  end
end
