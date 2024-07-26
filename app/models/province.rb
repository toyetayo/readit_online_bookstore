class Province < ApplicationRecord
  has_many :users
  has_many :orders

  validates :name, :gst_rate, :pst_rate, :hst_rate, :qst_rate, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[name gst_rate pst_rate hst_rate qst_rate created_at updated_at]
  end
end
