# config/initializers/stripe.rb
Rails.configuration.stripe = {
  publishable_key: ENV['pk_test_51PbPCUDsjvLUGLG3J68smAXwkmPS3PXd4QUF755W2uqTsa4hNmR7mnWsXRBKTdK2zI769yBsvLVL6VHUMknWA6IY00X86HsZxM'],
  secret_key: ENV['sk_test_51PbPCUDsjvLUGLG3Wd6GNXAvSXSl9TUJ8mWCIGhwR7LtaQkS8kBkUPpdtHhjRLIqiI9eonYXWNJpl2e6HdCD9gov00B5V7MZn3']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
