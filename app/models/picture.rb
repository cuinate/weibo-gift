class Picture < ActiveRecord::Base
  belongs_to :user
  has_attached_file :photo, 
                    :default_style => :thumb,
                    :styles => {
                      :card480  => "480x360#",
                      :card400  => "400x300#",                      
                      :card280  => "280x210#",                    
                    },
                    :url => "/system/picture/:id/:style/:filename"
  scope :is_card, where(:is_card => '1')
                    
end
