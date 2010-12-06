
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
		respond_to do |format|
			format.html # show.html.erb
			format.xml  { render :xml => @member }
		end
	end
	
	

end
