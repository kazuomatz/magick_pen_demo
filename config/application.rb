require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MagickPenDemo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.assets.precompile += %w( application.js application.css bulma/application.css bulma/application.js bootstrap/application.css bootstrap/application.js)

    I18n.available_locales = %i(ja en)
    I18n.enforce_available_locales = true
    I18n.default_locale = :ja

  end
end
