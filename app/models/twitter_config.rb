#require '/usr/local/lib/ruby/gems/1.8/gems/hpricot-0.6.164/ext/hpricot_scan/extconf.rb'
#require '/usr/local/lib/ruby/gems/1.8/gems/hpricot-0.6.164/lib/hpricot.rb'
#require '/usr/local/lib/ruby/gems/1.8/gems/twitter-0.4.2/lib/twitter.rb'
#require '/usr/local/lib/ruby/gems/1.8/gems/twitter-0.4.2/lib/twitter'
class TwitterConfig < ActiveRecord::Base

  belongs_to :user

  before_create :check_settings
  
  def check_settings
    if twitter_authorized?
      return true
    else
      self.errors.add(:twitter_password, ' may be incorrect. Please check your twitter username and password.')
      return false
    end
  end

  def twitter_authorized?
    twitter = Twitter::Client.new
    return twitter.authenticate?(self.twitter_username, self.twitter_password)
  end

end
