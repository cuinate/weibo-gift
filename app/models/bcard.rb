class Bcard < ActiveRecord::Base
  has_attached_file :pic, 
                    :default_style => :thumb,
                    :styles => {
                      :thumb  => "150x125#",
                      :thumb_b => "600x500#"
                    },
                    :url => "/system/bcard/:id/:style/:filename"
end
