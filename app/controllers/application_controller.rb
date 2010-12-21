class ApplicationController < ActionController::Base
  helper:all
  protect_from_forgery
  include OauthSystem
  #--------- get the current user's friends list and get the basic infor for each one -------#
    def get_user_friends
      #-1.-- get all friends back
       logger.info("[app]current oauthe ===#{self.oauth}")
      friends = self.friends()
      #-2.--- get the wanted information saved
      user_friends = Array.new
      friends.each do |f| 
        friend = Hash.new
        friend["weibo_id"]		= f["id"]
        friend["screen_name"] = f["screen_name"]
        friend["profile_image_url"] = f["profile_image_url"]
        user_friends.push(friend)
      end
      #session[:user_friends] = user_friends
      user_friends
      #-3--- save the user's friend into class instance variable  
      # @user = current_user
      #@user.user_friends = user_friends
      #logger.info("friends_id= #{@user.user_friends}")
    end
end
