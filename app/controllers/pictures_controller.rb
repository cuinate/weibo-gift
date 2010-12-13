class PicturesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  def new
     @picture = Picture.new
   end

   def create     

      @picture = Picture.new
      @picture.user_id =  params[:user_id]

      # Associate the correct MIME type for the file since Flash will change it
      params[:Filedata].content_type = MIME::Types.type_for(params[:Filedata].original_filename).to_s

      @picture.photo = params[:Filedata]
      if @picture.save
          session[:pic_id] = @picture.id
          logger.info("==== pic id =====")
          logger.info(session[:pic_id])
          
           respond_to do |format|
              #format.json { render :json => @picture}
              format.json {render :json =>  @picture.id }
           end        
      else
          render :json => { 'status' => 'error' }     
      end
  end    
end
