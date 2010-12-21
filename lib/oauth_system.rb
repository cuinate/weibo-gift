require 'oauth'

module OauthSystem
  
  # weibo api_key and api_secret 
  Weibo::Config.api_key = "2942145647"
  Weibo::Config.api_secret = "5cc0026c470a25a6070237e07ade5f27"
  

  
	class GeneralError < StandardError
	end
	class RequestError < OauthSystem::GeneralError
	end
	class NotInitializedError < OauthSystem::GeneralError
	end
 
  # controller method to handle twitter callback (expected after login_by_oauth invoked)

protected
  
    # Inclusion hook to make #current_user, #logged_in? available as ActionView helper methods.
    def self.included(base)
#		base.send :helper_method, :current_user, :oauth_login_required, :logged_in? if base.respond_to? :helper_method
		base.send :helper_method, :current_user, :logged_in? ,:friends if base.respond_to? :helper_method
    end

    # oAuth 
    def oauth 
        @oauth ||= Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
    end 
  
    # weibo_agent 
    
    def weibo_agent( user_token = nil, user_secret = nil )
      self.oauth.authorize_from_access(user_token, user_secret)
      self.weibo_agent = Weibo::Base.new(oauth) if user_token && user_secret
		  self.weibo_agent = Weibo::Base.new(oauth) unless @weibo_agent
		@weibo_agent ||= raise OauthSystem::NotInitializedError
    end
    
    def weibo_agent=(new_agent)
		@weibo_agent = new_agent || false
    end
   
    # Accesses the current user from the session.
    # Future calls avoid the database because nil is not equal to false.
    def current_user
		@current_user ||= (login_from_session) unless @current_user == false
    end
	
    # Sets the current_user, including initializing the OAuth agent
    def current_user=(new_user)
		if new_user
			session[:weibo_id] = new_user.weibo_id
			self.weibo_agent( user_token = new_user.token, user_secret = new_user.secret )
			@current_user = new_user
		else
			session[:rtoken] = session[:rsecret] = session[:weibo_id] = nil 
			self.weibo_agent = false
			@current_user = false
		end
    end

	def oauth_login_required
		logged_in? || login_by_oauth
	end

    # Returns true or false if the user is logged in.
    # Preloads @current_user with the user model if they're logged in.
    def logged_in?
		!!current_user
    end

    def login_from_session
		self.current_user = User.find_by_weibo_id(session[:weibo_id]) if session[:weibo_id]
    end

	def login_by_oauth
	  request_token = self.oauth.consumer.get_request_token
    session[:rtoken], session[:rsecret] = request_token.token, request_token.secret
    redirect_to "#{request_token.authorize_url}&oauth_callback=http://#{request.env["HTTP_HOST"]}/callback"
	rescue
		# The user might have rejected this application. Or there was some other error during the request.
		RAILS_DEFAULT_LOGGER.error "Failed to login via OAuth"
		flash[:error] = "WeiBo API failure (account login)"
		redirect_to root_url
	end

	# controller wrappers for weibo API methods	
	def friend_ids(query={})
	  logger.info("calling [friends_ids]")
	  self.weibo_agent.friend_ids(query)
	  rescue => err
  		RAILS_DEFAULT_LOGGER.error "Failed to get friends via OAuth for #{current_user.inspect}"
  		flash[:error] = "weibo API failure (getting friends)"
  		return
	end
	
	def user(id, query={})
	  self.weibo_agent.user(id, query)
	  rescue => err
  		RAILS_DEFAULT_LOGGER.error "Failed to get friends via OAuth for #{current_user.inspect}"
  		flash[:error] = "weibo API failure (getting friends)"
  		return
	end
	# get weibo friends :status friends (cursor based implementation)
	# return friends hash (next_cursor + users + previous_cursor)
	def one_page_friends(cursor = -1)
	  friend_query = {:count => 200, :cursor => cursor}
    logger.info("self.weibo_agent----#{self.weibo_agent}")
	  friends = self.weibo_agent.friends(friend_query)
	  #friends = Weibo::Base.new(oauth).friends(friend_query)
	  rescue => err
  		RAILS_DEFAULT_LOGGER.error "Failed to get one page friends via OAuth for #{current_user.inspect}"
  		flash[:error] = "weibo API failure (getting one page friends)"
  		return
	end
	# get weibo friends :status friends 
	# returns: array of all friends for the given user
	def friends
	      cursor = -1
    	  page = 0
    	  friends = []
    	  begin 
    	    friendspage = one_page_friends(cursor)
    	    page +=1
    	    friends += friendspage["users"] if friendspage
    	    cursor = friendspage["next_cursor"] 
    	  end until cursor == 0
    	  friends
   rescue => err
     	  RAILS_DEFAULT_LOGGER.error "exception in getting user's friends #{err}"
        raise err
        return
	end

	

	

	
end