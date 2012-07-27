class Site < ActiveRecord::Base
  has_many :posts


  has_and_belongs_to_many :users

  #validates_uniqueness_of :name
  validates_length_of :name, :minimum => 8

  before_create :parse_rss 
  after_create  :add_post
  attr :rss_link, true

  DEBUG = true
  def send_rss_updates(rss)
    return if rss.nil?
    return if rss.items.empty?
    post = self.posts.first
    #this shouldnt ever happen
    if post.nil?
      p = Post.new(:title => rss.items.first.link, :site_id => self.id)
      p.save!
      return
    end
    marker = 0
    ended = 0
    for i in 0..(rss.items.size - 1)
      ended += 1
      if rss.items[i].link == post.title
        marker = i
        break
      end
    end
    marker = 1 if ((ended == (rss.items.size)) and marker == 0)
    puts 'for site ' + self.name if DEBUG
    return if marker == 0
    for i in 0..(marker - 1)
      feed = rss.items[i]
      puts 'for feed ' + feed.link if DEBUG
      address = craigslist_replyto_from(feed)
      susers = self.users
      for chosen_suser in susers
        email = chosen_suser.email
        puts 'getting user email pref for ' + email + ' for site ' + self.name if DEBUG
        puts "searching for " + ":user_id => #{chosen_suser.user_id}, :site_id => #{self.id.to_s})" if DEBUG
        e_pref = Preference.find(:first, :conditions => { :user_id => chosen_suser.user_id, :site_id => self.id.to_s})
        send_update = false
        twitter_only = false
        twitter_self = false
        twitter_all = false
        if e_pref
          twitter_only = e_pref.twitter_only == true
          twitter_self = e_pref.twitter_self == true
          twitter_all = e_pref.twitter_all == true
          content = feed.title.to_s + ' ' + feed.description.to_s
          puts 'content for search is' + content.to_s if DEBUG
          puts 'keywords is ' + e_pref.keywords if DEBUG
          keywords = e_pref.keywords # + ' '
          #words = keywords.split(/\s|,|\s*,\s*/).uniq
          #include doing phrases now
          words = keywords.split(/(?:(\w+)|"((?:\\.|[^\\"])*)")(?:\^(\d+))?/).uniq
          words.delete('')
          words.delete(' ')
          puts 'keywords is ' + words.inspect if DEBUG
          #empty = words.index('') unless words.nil?
          #words = words.delete_at(empty) unless empty.nil?
          send_update = true if words.nil? or words.empty?
          for word in words
            if content.include?(word)
              puts 'word ' + word.to_s + ' was found' if DEBUG
              send_update = true
              break
            end
          end
        else
          puts 'no pref found' if DEBUG
          send_update = true
        end
        if send_update and not twitter_only
          puts 'sending mail ' 
          begin
            NewPost.deliver_new_post({ :replyto => address, :subject => feed.title.to_s, :text => 'RE: ' + feed.link.to_s + "\n\n" + feed.title.to_s + "\n\n" + feed.description.to_s + "\n\n" + feed.link.to_s, :recipients => "#{email}"})
            ActiveRecord::Base.connection.reconnect!
          rescue Exception => e
            ActiveRecord::Base.connection.reconnect!
            puts e
          end
            #
          #m = Merb::Mailer.new( :from => '"A New Post" <root@ec2-174-129-175-162.compute-1.amazonaws.com>', :replyto => address, :subject => feed.title.to_s, :text => 'RE: ' + feed.link.to_s + "\n\n" + feed.title.to_s + "\n\n" + feed.description.to_s + "\n\n" + feed.link.to_s, :to => "#{email}")
          puts 'sent mail'
          #m.deliver!
        end
        if send_update and (twitter_self or twitter_all)
          msg = (feed.title + ' - ' + feed.link + ' - ' + feed.description)[0,140]
          user_config = chosen_suser.user_config
          twitter = Twitter::Client.new(:login => user_config.twitter_username, :password => user_config.twitter_password)
          if twitter_self
            puts 'sending update to self' if DEBUG
            id = twitter.user(user_config.twitter_username).id
            twitter.message(:post, msg, id)
          end
          if twitter_all
            puts 'sending update to all' if DEBUG
            twitter.status(:post, msg)
          end
        end
      end
    end
    begin
      post = self.posts.first
      post.update_attributes({:title => rss.items.first.link })
    rescue ActiveRecord::StatementInvalid
      ActiveRecord::Base.connection.reconnect!
      post.update_attributes({:title => rss.items.first.link })
    rescue Exception => e 
      puts e
    end
  end

  def parse_rss
    begin
      self.rss_link = SimpleRSS.parse open(self.name)
    rescue Exception => e
      puts e
      self.errors.add(:name, 'couldn not find that url. Please make sure you enter a valid rss feed address.')
      #self.destroy
      return false 
    end
  end

  def add_post
    p = Post.new(:title => self.rss_link.items.first.link, :site_id => self.id)
    p.save!
  end

  private

  def craigslist_replyto_from(feed)
    a = WWW::Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }
    address = 'invalidreply'
    if feed.link.include?('craigslist')
      begin
        a.get(feed.link.to_s) do |page|
        mail = page.links[10]
        #puts mail.href
        if mail
          address = mail if mail
        else
          address = 'noreply'
        end
      end
      rescue Iconv::IllegalSequence
        puts 'malformed html - skipping reply to'
      end
    end
    return address
  end



end
