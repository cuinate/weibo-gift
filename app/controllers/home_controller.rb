class HomeController < ApplicationController
  def index 
    respond_to do |format|
      format.html # show.html.erb
      #format.mobi { render :layout => false }
    end
  end
end
