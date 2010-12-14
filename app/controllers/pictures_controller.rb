class PicturesController < ApplicationController
  require 'jcode'
  require 'find'
  skip_before_filter :verify_authenticity_token, :only => :create
  
  FONT_SIZE = 25  # 字体大小
  WIDTH = 350 # 设置文字显示区域的宽度，用于计算每行字数
  NUM_WORD_PER_LINE = (WIDTH/FONT_SIZE).round
     
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
   
   def card_compose
     @picture = Picture.new
     card_pic_id        = params[:card_pic_id]
		 input_text         = params[:input_text]
		 background_pic     = params[:background_pic] 

		 @user_pic = Picture.find_by_id(card_pic_id)
		 
		 user_pic_url_origin= @user_pic.photo.url(:card)
		 splitted_url = user_pic_url_origin.split("?")
		 user_pic_url = splitted_url[0]
		 
		 logger.info("==== card compose :: user_pic_url")
		 logger.info(user_pic_url)
		 # long text parser        
      $KCODE='utf8'
      d_str =''
      input_text.each {|s_str| 
        while s_str.jsize > NUM_WORD_PER_LINE
          tmp_str = s_str.scan(/./)[0,NUM_WORD_PER_LINE].join
          d_str += tmp_str + "\n\n"
          s_str = s_str[tmp_str.size,s_str.size-tmp_str.size]
          if s_str == nil then break end
          #puts s_str.jsize  
        end
        if s_str!=nil then d_str += s_str end
        d_str += "\n"
      }

      #--- path and name. to be config/updated in new environments
      font_path = 'public/fonts/'
      images_path = "public/images"
      output_path = 'public/system/outputs'
      bg_image_path = images_path + "/background/big/"+ background_pic

      # do the same thing for each available fonts
      Find.find(font_path) do |f|
        if /[tT][tT][fF]/.match(f)==nil then next end
        img = Magick::Image.read(bg_image_path).first    #图片路径
        src_img = Magick::Image.read("public/" + user_pic_url).first  # to be replaced with user's picture url
        #src_img.crop_resized!(320,320)  # 照片的目标尺寸
        #src_img.border!(10, 10, "#f0f0ff")    #相框的颜色，宽度
        frame_img = Magick::Image.read(images_path+'/frame.png').first    # picture frame
        frame_img.composite!(src_img, 10, 10, Magick::OverCompositeOp)
        img.composite!(frame_img, 20, 20, Magick::OverCompositeOp)

        gc= Magick::Draw.new
        gc.annotate(img, 0, 0, 420, 50, d_str) do  #可以设置文字的位置，参数分别为路径、宽度、高度、横坐标、纵坐标
          #self.gravity = Magick::CenterGravity
          self.font = f
          #self.font = font_path + 'fz_shaoer.ttf' 
          self.pointsize = FONT_SIZE                 #字体的大小
          self.fill = '#fff'                         #字体的颜色
          self.stroke = "none"
        end          
        font_file_name = File.basename(f, 'ttf')
       #font_file_name = "fz_shaer"
        file_path = output_path + "/"+ font_file_name + ".png"  
        img.write(file_path)  
      end
     
   end 
end
