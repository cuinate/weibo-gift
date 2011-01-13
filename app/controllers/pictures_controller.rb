class PicturesController < ApplicationController
  require 'jcode'
  require 'find'
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
          
 #         unless params[:Filedata].blank?
 #           render :action => 'cropping', :format =>js
 #         end
        respond_to do |format|
              #format.json { render :json => @picture}
          format.json {render :json =>  @picture.id }
        end        
      else
          render :json => { 'status' => 'error' }     
      end
   end   
   
   def update
    @picture = Picture.find(params[:id])
    session[:upload_pic_id] = params[:id]
    if @picture.update_attributes(params[:picture])
      flash[:notice] = 'User was successfully updated.'
      if params[:picture][:photo].blank?
        #redirect_to createcard_path,:temp_which => "post", :format => 'js'
        redirect_to :controller => 'users', :action => "create_card",:temp_which => "post"
      else
        render :action => 'cropping'
      end
    else
      render :action => "edit"
    end
  end
  
   def cropping
    pic_id = params[:pic_id]
    @picture = Picture.find_by_id(pic_id)
    @pic_url = @picture.photo.url(:back1024)
  
   
    respond_to do |format|
     format.html # 
     format.js
    end
   end
   def card_compose
     
     @out_file_path = ''
     @user = current_user
     @final_img =''
     @d_str=''
     @picture = Picture.new
     @card_photo_url	  = params[:card_photo_url]
		 input_text         = params[:input_text]
		 template_id        = session[:temp_id] # get the template ID from session
     temp_which         = params[:temp_which]

    
  		 #@user_pic = Picture.find_by_id(card_pic_id)
  		 #user_pic_url_origin= @user_pic.photo.url(:card)
  		 #splitted_url = user_pic_url_origin.split("?")
  		 splitted_url = @card_photo_url.split("?")		 
  		 @user_pic_url = splitted_url[0]  # the url of photo user just uploaded
  		 logger.info("~~~~~~~~ the url of photo user: public+#{@user_pic_url}")

       font_size = 25
       #input_width = @template.input_width
       input_width = 560
       num_word_per_line = (input_width/font_size).round
       
       # long text parser        
       $KCODE='utf8'
       @d_str =''
       input_text.each {|s_str| 
          while s_str.jsize > num_word_per_line
            tmp_str = s_str.scan(/./)[0,num_word_per_line].join
            @d_str += tmp_str + "\n"
            s_str = s_str[tmp_str.size,s_str.size-tmp_str.size]
            if s_str == nil then break end
            #puts s_str.jsize  
          end
          if s_str!=nil then @d_str += s_str end
          @d_str += "\n"
        }


       #--- path and name. to be config/updated in new environments
        font_path = 'public/fonts/fz_shaoer.ttf'
        output_path = 'public/system/outputs'
        

           #@bcard_pic = Bcard.find_by_id(template_id) 
           #bcard_pic_url = @bcard_pic.pic.url(:thumb_b)
           img = Magick::Image.read('public'+@user_pic_url).first #bg_image_path).first 
           
          card_back_path = 'public/images/background/temp_frame.png'
          @final_img = Magick::Image.read(card_back_path).first  
          #final_img = Magick::Image.new(640,640,Magick::HatchFill.new('white','white'))
          #@final_img.composite!(img, 25, 25, Magick::OverCompositeOp)
          @final_img.composite!(img, 33, 34, Magick::OverCompositeOp)
  
          gc= Magick::Draw.new
          #gc.annotate(img, 0, 0, @template.input_x, @template.input_y, d_str) do  #可以设置文字的位置，参数分别为路径、宽度、高度、横坐标、纵坐标
          #gc.annotate(@final_img, 0, 0, 40, 550, @d_str) do  #可以设置文字的位置，参数分别为路径、宽度、高度、横坐标、纵坐标
          gc.annotate(@final_img, 0, 0, 40, 565, @d_str) do  #可以设置文字的位置，参数分别为路径、宽度、高度、横坐标、纵坐标
            #self.gravity = Magick::CenterGravity
            self.font = font_path #f
            self.pointsize = font_size                 #字体的大小
            self.fill = '#000'                         #字体的颜色
            self.stroke = "none"
          end          

          @out_file_path = output_path + "/"+ "final_card.png"  
          @final_img.write(@out_file_path) 
          logger.info("----- outpu_file_path:____" + @out_file_path)        
        #end
      #------ "bolilai card creation #

    
      # --- save the file to user.picture using paperclip
      aFile = File.new(@out_file_path)
      # ... process the file
      @picture.photo =  File.new(@out_file_path)
      
      @picture.user_id = @user.id
      @picture.is_card = 1 # save this picture as greeting cards
      # Associate the correct MIME type for the file since Flash will change it
      #aFile.content_type = MIME::Types.type_for(aFile.original_filename).to_s

      @picture.photo = aFile
      logger.info("----- current_file____")
      logger.info(@picture.photo)
      
      # --- save the picture
      if @picture.save
          aFile.close
           respond_to do |format|
              format.js
              format.json {render :json =>  @picture.id }
           end        
      else
          render :json => { 'status' => 'error' }     
      end
     
   end 
end
