class PicturesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  def new
     @picture = Picture.new
   end

   def create
     
      weibo_id  = session[:weibo_id]
      logger.info("====== weibo_id: ==== #{weibo_id}")
      #@user = User.find_by_weibo_id(session[:weibo_id])

      #logger.info("====== user_is: ==== #{@user.screen_name}")
      @picture = Picture.new
      @picture.user_id =  params[:user_id]

      # Associate the correct MIME type for the file since Flash will change it
      params[:Filedata].content_type = MIME::Types.type_for(params[:Filedata].original_filename).to_s

      @picture.photo = params[:Filedata]
      if @picture.save
          render :json => { 'status' => 'success'  }
      else
          render :json => { 'status' => 'error' }     
      end
  end    
end
