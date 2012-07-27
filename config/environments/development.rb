# Settings specified here will take precedence over those in config/environment.rb
#require '/usr/local/lib/ruby/gems/1.8/gems/simple-rss-1.1/lib/simple-rss.rb'
#require '/usr/local/lib/ruby/gems/1.8/gems/rest-open-uri-1.0.0/lib/rest-open-uri.rb'
#require 'simple-rss'
#require 'twitter'
# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
#ENV['GEM_PATH'] ||= "/Users/lemynshij/.gem"
#ENV['GEM_HOME'] ||= "/Users/lemynshij/.gem"
#system("export GEM_PATH = /Users/lemynshij/.gem")
#system("export GEM_HOME = /Users/lemynshij/.gem")

# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false
HOST = 'localhost:3000'
