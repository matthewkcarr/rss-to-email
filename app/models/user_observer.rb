class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.deliver_signup_notification(user)
  end

  def after_save(user)
  
    #to do this we have to change the way activation works
    #UserMailer.deliver_activation(user) if user.recently_activated?
  
  end
end
