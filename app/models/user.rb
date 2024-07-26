class User < ApplicationRecord
  belongs_to :province, foreign_key: 'province_id', optional: true
  has_many :orders, dependent: :destroy
  has_many :shopping_cart_items, dependent: :destroy

  # Validations
  validates :username, presence: true, uniqueness: true
  validates :email, :encrypted_password, presence: true
  validates :first_name, :last_name, :address, :city, :zip, :phone_number, :province_id, presence: true, on: :update

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.ransackable_attributes(auth_object = nil)
    %w[address city created_at email first_name id last_name phone_number province_id updated_at zip]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[orders shopping_cart_items province]
  end
end
