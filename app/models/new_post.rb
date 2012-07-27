class NewPost < ActionMailer::Base
  
  def new_post(options)
    setup_email(options[:recipients], options[:subject], options[:replyto])
    @body[:text] = options[:text]
  end

  def setup_email(recipients, subject = '[rss-to-email] Info', replyto = '', from = 'matt@rss-to-email.com' , sent_on = Time.now)
    #require 'socket'
    @recipients = recipients
    @subject    = subject
    @from       = from
    @sent_on    = Time.now
    @reply_to   = replyto
  end


end
