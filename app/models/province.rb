class Province < ApplicationRecord
  has_many :users
  has_many :orders

  validates :name, :gst_rate, :pst_rate, :hst_rate, :qst_rate, presence: true
end
