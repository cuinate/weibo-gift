class HomeController < ApplicationController
  def index 
    if current_user
      logger.info("=== current user is :")
      logger.info(current_user.screen_name)
    else
      logger.info("no user in now")
    end
    respond_to do |format|
      format.html # show.html.erb 
      #format.mobi { render :layout => false }
    end
  end
end
