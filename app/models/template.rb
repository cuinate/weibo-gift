class Template < ActiveRecord::Base
  has_attached_file :pic, 
                    :default_style => :thumb,
                    :styles => {
                      :thumb  => "200x150#"
                    },
                    :url => "/system/template/:id/:style/:filename"
end
