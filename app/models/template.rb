class Template < ActiveRecord::Base
  has_attached_file :pic, 
                    :default_style => :thumb,
                    :styles => {
                      :thumb  => "200x150#",
                      :thumb_b => "400x300#"
                    },
                    :url => "/system/template/:id/:style/:filename"
  has_attached_file :back, 
                    :url => "/system/template/:id/back/:filename"
end
