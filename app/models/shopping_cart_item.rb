class ShoppingCartItem < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }

  def total_price
    product.price * quantity
  end

  def total_price_with_tax
    total_price * (1 + tax_rate)
  end

  private

  def tax_rate
    if user.present?
      calculate_tax_rate_for_user
    else
      calculate_tax_rate_for_guest
    end
  end

  def calculate_tax_rate_for_user
    province = user.province
    gst = province.gst_rate || 0
    pst = province.pst_rate || 0
    hst = province.hst_rate || 0
    qst = province.qst_rate || 0

    (gst + pst + hst + qst).to_f / 100
  end

  def calculate_tax_rate_for_guest
    default_province = Province.find_by(name: 'default') # Adjust to your default province or handle appropriately
    gst = default_province.gst_rate || 0
    pst = default_province.pst_rate || 0
    hst = default_province.hst_rate || 0
    qst = default_province.qst_rate || 0

    (gst + pst + hst + qst).to_f / 100
  end
end
