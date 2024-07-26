# tax_calculator_test.rb
require './app/services/tax_calculator'

def test_tax_calculator(subtotal, province)
  tax_details = TaxCalculator.calculate_total_price(subtotal, province)
  puts "Province: #{province}"
  puts "Subtotal: $#{'%.2f' % subtotal}"
  puts "GST: $#{'%.2f' % tax_details[:gst]}"
  puts "PST: $#{'%.2f' % tax_details[:pst]}"
  puts "HST: $#{'%.2f' % tax_details[:hst]}"
  puts "QST: $#{'%.2f' % tax_details[:qst]}" if tax_details.key?(:qst)
  puts "Total Price: $#{'%.2f' % tax_details[:total_price]}"
  puts '----------------------------------------'
end

# Test cases
test_tax_calculator(100.0, 'AB') # Alberta
test_tax_calculator(100.0, 'BC') # British Columbia
test_tax_calculator(100.0, 'MB') # Manitoba
test_tax_calculator(100.0, 'NB') # New Brunswick
test_tax_calculator(100.0, 'QC') # Quebec
test_tax_calculator(100.0, 'ON') # Ontario
