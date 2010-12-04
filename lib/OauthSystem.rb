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
		base.send :helper_method, :current_user, :logged_in? if base.respond_to? :helper_method
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

	

	# controller wrappers for twitter API methods

	# Twitter REST API Method: statuses/update
	def update_status!(  status , in_reply_to_status_id = nil )
		self.twitagent.update_status!(  status , in_reply_to_status_id )
	rescue => err
		# The user might have rejected this application. Or there was some other error during the request.
		RAILS_DEFAULT_LOGGER.error "#{err.message} Failed update status"
		return
	end

	# Twitter REST API Method: statuses friends
	def friends(user=nil)
		self.twitagent.friends(user)
	rescue => err
		RAILS_DEFAULT_LOGGER.error "Failed to get friends via OAuth for #{current_user.inspect}"
		flash[:error] = "Twitter API failure (getting friends)"
		return
	end

	# Twitter REST API Method: statuses followers
	def followers(user=nil)
		self.twitagent.followers(user)
	rescue => err
		RAILS_DEFAULT_LOGGER.error "Failed to get followers via OAuth for #{current_user.inspect}"
		flash[:error] = "Twitter API failure (getting followers)"
		return
	end

	# Twitter REST API Method: statuses mentions
	def mentions( since_id = nil, max_id = nil , count = nil, page = nil )
		self.twitagent.mentions( since_id, max_id, count, page )
	rescue => err
		RAILS_DEFAULT_LOGGER.error "Failed to get mentions via OAuth for #{current_user.inspect}"
		flash[:error] = "Twitter API failure (getting mentions)"
		return
	end

	# Twitter REST API Method: direct_messages
	def direct_messages( since_id = nil, max_id = nil , count = nil, page = nil )
		self.twitagent.direct_messages( since_id, max_id, count, page )
	rescue => err
		RAILS_DEFAULT_LOGGER.error "Failed to get direct_messages via OAuth for #{current_user.inspect}"
		flash[:error] = "Twitter API failure (getting direct_messages)"
		return
	end

	
end