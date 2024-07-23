class Province < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :orders, dependent: :destroy
  validates :name, :gst_rate, :pst_rate, :hst_rate, :qst_rate, presence: true
end
