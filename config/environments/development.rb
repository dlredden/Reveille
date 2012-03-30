# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# We care if the mailer can't send
config.action_mailer.raise_delivery_errors = true

# Set default message format
config.action_mailer.default_content_type = "text/html"

# set delivery method to :smtp, :sendmail or :test
config.action_mailer.delivery_method = :smtp

# these options are only needed if you choose smtp delivery
config.action_mailer.smtp_settings = {
  :address        => 'smtp.1and1.com',
  :port           => 25,
  :authentication => :login,
  :domain         => 'wikidlabs.com',
  :user_name      => 'hello@wikidlabs.com',
  :password       => 'Wikidpass789!'
}
