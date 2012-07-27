#!/usr/bin/env ruby
ENV['RAILS_ENV'] ||= 'production'
require File.dirname(__FILE__) + '/../config/environment'
for site in Site.find(:all)
  #begin
    rss = SimpleRSS.parse open(site.name)
    site.send_rss_updates(rss)
  #rescue
  #end
end

