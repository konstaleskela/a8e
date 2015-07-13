Entertainment::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  config.time_zone = "Helsinki"

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

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # SMTP settings
  config.action_mailer.smtp_settings = {
   :address => "mail.ymme.info", :port => "587",
   :authentication => :plain, :enable_starttls_auto => true,
   :user_name => "fiksu@ymme.info", :password => "AG234RWe#qwER32fsZx"
  }

  #config.action_mailer.perform_deliveries = false
end
