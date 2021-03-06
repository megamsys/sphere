Cwic::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Disable mailer
  config.action_mailer.perform_deliveries = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = false

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  # [2013-06-10 kevin] Disables assets debug for better development performance
  config.assets.debug = false

  # [2013-11-08] Delete Rack::Lock, this was needed for some reason to fix the internal server error which occured when using the websocket-rails
  config.middleware.delete Rack::Lock

  # Precompile assets (needed for js-routes)
  config.assets.initialize_on_precompile = true

  # ActionMailer default sender host
  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  # Bullet config
  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.console = true
    Bullet.rails_logger = true
    Bullet.add_footer = true
  end
end
