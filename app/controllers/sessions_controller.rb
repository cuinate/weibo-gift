class SessionsController < ApplicationController
  
	def callback
	  logger.info("get called in callback")
	  self.oauth.authorize_from_request(session[:rtoken], session[:rsecret], params[:oauth_verifier])
    session[:rtoken], session[:rsecret] = nil, nil
    session[:atoken], session[:asecret] = oauth.access_token.token, oauth.access_token.secret

	  user_info =  self.weibo_agent.verify_credentials		
		raise OauthSystem::RequestError unless user_info['id'] && user_info['screen_name'] && user_info['profile_image_url']
		# We have an authorized user, save the information to the database.
		@user = User.find_by_screen_name(user_info['screen_name'])
		# get user's friend 
		#user_friends = get_user_friends()		
		if @user
			@user.token = session[:atoken]
			@user.secret = session[:asecret] 
			@user.profile_image_url = user_info['profile_image_url']
		else
			@user = User.new({ 
				:weibo_id => user_info['id'],
				:screen_name => user_info['screen_name'],
				:token => session[:atoken],
				:secret => session[:asecret] ,
				:profile_image_url => user_info['profile_image_url']})
		end
		if @user.save
			self.current_user = @user		
		else
			raise OauthSystem::RequestError
		end
		# Redirect to the show page
	  
		redirect_to user_path(@user)

  	rescue
  		# The user might have rejected this application. Or there was some other error during the request.
  		RAILS_DEFAULT_LOGGER.error "Failed to get user info via OAuth"
  		flash[:error] = "weibo API failure (account login)"
  		redirect_to root_url
	end
	
	
	# controller method to handle logout
	def signout
		self.current_user = false 
		reset_session
		flash[:notice] = "You have been logged out."
		redirect_to root_url
	end
	
	
end
