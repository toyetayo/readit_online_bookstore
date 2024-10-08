class TaxCalculator
  TAX_RATES = {
    'AB' => { gst: 0.05, pst: 0.0, hst: 0.0 }, # Alberta
    'BC' => { gst: 0.05, pst: 0.07, hst: 0.0 }, # British Columbia
    'MB' => { gst: 0.05, pst: 0.07, hst: 0.0 }, # Manitoba
    'NB' => { gst: 0.05, pst: 0.0, hst: 0.15 }, # New Brunswick
    'NL' => { gst: 0.05, pst: 0.0, hst: 0.15 }, # Newfoundland and Labrador
    'NS' => { gst: 0.05, pst: 0.0, hst: 0.15 }, # Nova Scotia
    'NT' => { gst: 0.05, pst: 0.0, hst: 0.0 }, # Northwest Territories
    'NU' => { gst: 0.05, pst: 0.0, hst: 0.0 }, # Nunavut
    'ON' => { gst: 0.05, pst: 0.0, hst: 0.13 }, # Ontario
    'PE' => { gst: 0.05, pst: 0.0, hst: 0.15 }, # Prince Edward Island
    'QC' => { gst: 0.05, pst: 0.0, hst: 0.0, qst: 0.09975 }, # Quebec
    'SK' => { gst: 0.05, pst: 0.06, hst: 0.0 }, # Saskatchewan
    'YT' => { gst: 0.05, pst: 0.0, hst: 0.0 } # Yukon
  }

  def self.calculate_total_price(subtotal, province_id)
    rates = TAX_RATES[province_id] || { gst: 0.05, pst: 0.0, hst: 0.0, qst: 0.0 }
    gst = rates[:gst]
    pst = rates[:pst]
    hst = rates[:hst]
    qst = rates[:qst]

    gst_amount = subtotal * gst
    pst_amount = subtotal * pst
    hst_amount = subtotal * hst
    qst_amount = subtotal * qst
    total_tax = gst_amount + pst_amount + hst_amount + qst_amount
    total_price = subtotal + total_tax

    {
      subtotal:,
      gst:         gst_amount,
      pst:         pst_amount,
      hst:         hst_amount,
      qst:         qst_amount,
      total_price:
    }
  end
end
