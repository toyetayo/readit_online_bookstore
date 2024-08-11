class AdminUser < ApplicationRecord
  # Devise modules for authentication and account management
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  # Ransackable attributes for searching
  def self.ransackable_attributes(auth_object = nil)
    %w[created_at email id remember_created_at reset_password_sent_at reset_password_token
       updated_at]
  end

  private

  # This method is used to determine if password validation is required
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end
end
