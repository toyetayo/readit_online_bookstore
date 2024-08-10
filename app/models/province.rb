class Province < ApplicationRecord
  has_many :users, dependent: :nullify
  has_many :orders, dependent: :nullify

  validates :name, :gst_rate, :pst_rate, :hst_rate, :qst_rate, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[name gst_rate pst_rate hst_rate qst_rate created_at updated_at]
  end
end
