class Picture < ActiveRecord::Base
  belongs_to :user
  has_attached_file :photo, 
                    :default_style => :thumb,
                    :styles => {
                      :card1  => "480x360#",
                      :card2  => "400x300#",                      
                      :card3  => "280x210#",                    
                    },
                    :url => "/system/picture/:id/:style/:filename"
  scope :is_card, where(:is_card => '1')
                    
end
