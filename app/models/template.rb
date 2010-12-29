class Template < ActiveRecord::Base
  has_attached_file :pic, 
                    :default_style => :thumb,
                    :styles => {
                      :thumb  => "150x125#",
                      :thumb_b => "600x500#"
                    },
                    :url => "/system/template/:id/:style/:filename"
  has_attached_file :back, 
                    :url => "/system/template/:id/back/:filename"  
  has_attached_file :frame,
                    :url => "/system/template/:id/frame/:filename"  
                  
end
