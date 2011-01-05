class Picture < ActiveRecord::Base
  belongs_to :user
  has_attached_file :photo,  
                    :default_style => :card280,
                    :styles => {                      
                      :card280  => "280x210#", 
                      :card163  => "163x163"
                    },
                    :url =>"/system/picture/:id/:style/:filename"
  scope :is_card, where(:is_card => '1')
                    
end
