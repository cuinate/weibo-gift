
class UsersController < ApplicationController
  before_filter :oauth_login_required, :except => [ :callback, :signout, :index ]
  
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
	  respond_to do |format|
      format.js
    end
	end
	
	def create_card_input
	  pic_id = params[:pic_id]
	  @pic = Picture.find_by_id(pic_id)
	  respond_to do |format|
	   format.html # create_card_input.html.erb
	   format.js
    end
  end
	

end
