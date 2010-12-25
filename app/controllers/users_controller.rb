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
	def show
	  # get the template 
	  @templates = Template.all
		respond_to do |format|
			format.html # show.html.erb
			format.xml  { render :xml => @member }
		end
	end
	
	def create_card
	  @template = Template.find_by_id(params[:temp_id])
	  session[:temp_id] = params[:temp_id]
	  @card_back_div_style = "background:url(" + @template.back.url + ")"
	  
	  #--- selection picture div coordination
	  pic_x = @template.pic_x.to_s
	  pic_y = @template.pic_y.to_s
	  pic_width = @template.pic_width.to_s
	  pic_height = @template.pic_height.to_s
	  @card_pic_sel_div_style = "top:" + pic_y + "px;left:" + pic_x + "px;width:" + pic_width + "px;height:" + pic_height + "px;"
	  
	  @card_pic_div_style = "width:" + pic_width + "px;height:" + pic_height + "px;"
	  #---- text input box div coordination
    input_x = @template.input_x.to_s
	  input_y = @template.input_y.to_s
	  input_width = (@template.input_width + 10).to_s
	  input_height = (@template.input_height + 10).to_s
	  @card_input_div_style = "top:" + input_y + "px;left:" + input_x + "px;width:" + input_width + "px;height:" + input_height + "px;"
	  
	  #---- text input area coordination style
	  text_width = @template.input_width.to_s
	  text_height = @template.input_height.to_s
	  @card_input_text_style = "width:" + text_width + "px;height:" + text_height +"px;"
	  logger.info(@card_back_div_style)
	  respond_to do |format|
      format.js
    end
	end
	
	def create_card_input
	  pic_id = params[:pic_id]
	  @pic = Picture.find_by_id(pic_id)
	  
	  temp_id = session[:temp_id]
	  @template = Template.find_by_id(temp_id)
	  if @template.pic_width == 480 
	     @pic_url = @pic.photo.url(:card480)
	  elsif @template.pic_width == 400
	     @pic_url = @pic.photo.url(:card400)
	  else
	     @pic_url = @pic.photo.url(:card280)
	  end
	 
	 
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
    
#    @card_pic = Picture.find_by_id(params[:card_pic_id])
#    @card_pic_demo_url = @card_pic.photo.url(:card400)
    
    respond_to do |format|
	   format.html # create_card_input.html.erb
	   format.js
    end
  
  end
#--------- protected methods -------------#
protected


end
