class Picture < ActiveRecord::Base
  belongs_to :user
  has_attached_file :photo, 
                    :default_style => :thumb,
                    :styles => {
                      :thumb => "100x50#",
                      :card  => "360x360#"
                    },
                    :url => "/system/picture/:id/:style/:filename"
                    
end
