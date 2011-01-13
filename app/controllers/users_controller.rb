class UsersController < ApplicationController
#  include OauthSystem
  before_filter :oauth_login_required, :except => [ :callback, :signout, :index ]
  @user_friends = Array.new
  def index
	end

	def new
		# this is a do-nothing action, provided simply to invoke authentication
		# on successful authentication, user will be redirected to 'show'
		# on failure, user will be redirected to 'index'
	end
	
	# GET /members/1
	# GET /members/1.xml
	def show_bcard
    # get the bcards pictures
    session[:upload_pic_id] = 0
    @bcards = Bcard.all 
		respond_to do |format|
			format.html # show.html.erb
		end
end

   def show_post
    # get the template 
    @templates = Template.all
    respond_to do |format|
      format.html # show.html.erb
    end
  end
	
	def create_card
    @which_card = params[:temp_which] 
    @card_photo_url =''
    if(@which_card == "post")#post-card 
      if session[:upload_pic_id] !=0
        @upload_pic = Picture.find_by_id(session[:upload_pic_id])
        @card_back_div_style = "background:url(" + @upload_pic.photo.url(:back500) + ")"
        @card_photo_url = @upload_pic.photo.url(:back500)
      else
  	     @card_back_div_style = "background:url(../images/card_big_back.png) no-repeat"
      end
    else # "bolilai" card
      @bcard = Bcard.find_by_id(params[:temp_id])    
      @card_back_div_style = "background:url(" + @bcard.pic.url(:thumb_b) + ")"
      @card_photo_url =@bcard.pic.url(:thumb_b)
    end
	  respond_to do |format|
      format.js
      format.html
    end
	end
	
	def create_card_input
	  pic_id = params[:pic_id]
	  @pic = Picture.find_by_id(pic_id)
	  @pic_url = @pic.photo.url(:back1024)
	
	 
	  respond_to do |format|
	   format.html # create_card_input.html.erb
	   format.js
    end
  end
  
# --- get the current_user's friends list 
  def get_friends
  
    @user = current_user
#    user_token  = current_user.token
#    user_secret = current_user.secret
#    logger.info("[user]current oauthe ===#{self.oauth}")
#    self.oauth.authorize_from_access(user_token, user_secret)
#    self.weibo_agent = Weibo::Base.new(oauth)
 
     @user_friends = get_user_friends()
      @card_pic_id = params[:card_pic_id]
     @card_pic = Picture.find_by_id(params[:card_pic_id])
     @card_pic_url = @card_pic.photo.url(:back500)
#    logger.info(@card_pic_demo_url)
     splitted_url = @card_pic_url.split("?")		 
  	 @user_card_url = splitted_url[0]  # the url of photo user just uploaded
     @tweet_pic_back_style = "background:url(" + @user_card_url + ") no-repeat"
    respond_to do |format|
	   format.html # get_friends.html.erb
	   format.js
    end
  
  end
#--------- protected methods -------------#
 def send_card
   @friends_id = params[:friends_id]
   card_id = params[:card_pic_id]
   logger.info("--- friends_id : ---#{@friends_id}")
   @card_pic = Picture.find_by_id(params[:card_pic_id])
   @card_pic_demo_url = @card_pic.photo.url(:back500)
   logger.info(@card_pic_demo_url)
   splitted_url = @card_pic_demo_url.split("?")		 
	 @user_card_url = splitted_url[0]  # the url of photo user just uploaded
	 @user_card_url = "public" + @user_card_url
	 status ="送个卡给你！"+"@"+@friends_id[0]
	 logger.info("---微波 -- status #{status}")
	 aFile = File.new(@user_card_url)
	 upload_card(status,aFile)
	 #--- send card via weibo gem 
	 respond_to do |format|
	   format.html # create_card_input.html.erb
	   format.js
	   format.json
   end
   
 end
protected


end
