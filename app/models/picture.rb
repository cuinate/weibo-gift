class Picture < ActiveRecord::Base
  PHOTO_BW = 1024
  PHOTO_BH = 600
  belongs_to :user
  has_attached_file :photo,  
                    :default_style => :back500,
                    :styles => {                      
                      :back500  => "500x500>",
                      :back1024 => "1024x600>"
                    },
                    :processors => [:jcropper],
                    :url =>"/system/picture/:id/:style/:filename"
  scope :is_card, where(:is_card => '1')
  after_update :reprocess_avatar, :if => :cropping?
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end
    
  def photo_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file photo.path(style)
  end
  
  private
  
  def reprocess_avatar
    photo.reprocess!
  end
                    
end
