require 'dotenv-rails'

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module ReaditOnlineBookstore
  class Application < Rails::Application
    config.load_defaults 7.1
    config.autoload_lib(ignore: %w[assets tasks])
    config.stripe.secret_key = ENV['STRIPE_SECRET_KEY']
  end
end
