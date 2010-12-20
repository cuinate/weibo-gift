class ApplicationController < ActionController::Base
  protect_from_forgery
  include OauthSystem
  
#--------- get the current user's friends list and get the basic infor for each one -------#
  def get_user_friends
    #-1.-- initiate the friend query 
    friend_query = "{"count" => 20, "cursor" => -1}"
    logger.info("friends query ----#{friend_query}")
    friends = self.friends(friend_query)
    logger.info("friends----#{friends}")
    #-2.--- get the first 200 member's page
    
    #friend_ids = Hash.new
    #user_friends = Array.new
    #friend_ids = self.friend_ids()['ids'];
    #---- get the friend's basic info 
    #friend_ids.each do |f_id| 
    #  logger.info("geting the friend' details info")
    #  friend_info = self.user(f_id)
    #  friend = Hash.new
    #  friend["weibo_id"]		= friend_info["id"]
    #  friend["screen_name"] = friend_info["screen_name"]
    #  friend["profile_image_url"] = friend_info["profile_image_url"]
    #  user_friends.push(friend)
    #end
    #logger.info("---user's friend info --#{user_friends}")
    #--- save the user's friend into class instance variable  
    # current_user.user_friends = user_friends
    #logger.info("friends_id= #{@user_friends}")
    #logger.info("friends_id= #{current_user.user_friends}")
  end
end
