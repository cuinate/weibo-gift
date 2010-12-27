class ApplicationController < ActionController::Base
  helper:all
  protect_from_forgery
  include OauthSystem
  require 'will_paginate'
  #--------- get the current user's friends list and get the basic infor for each one -------#
    def get_user_friends
      
      #-1. asdfget or update all current users friends back from weibo
      friends = self.friends()
      #-2.-get/update the wanted information saved
      user_friends = Array.new
      friends.each do |f| 
        user_id = current_user.id
        friend = Hash.new
        friend["weibo_id"]		= f["id"]
        friend["screen_name"] = f["screen_name"]
        friend["profile_image_url"] = f["profile_image_url"]
        user_friends.push(friend)
      end
      user_friends
      
      #-3--- save the user's friend into class instance variable  
      # @user = current_user
      #@user.user_friends = user_friends
      #logger.info("friends_id= #{@user.user_friends}")
    end
end
