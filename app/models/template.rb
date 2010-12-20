class Template < ActiveRecord::Base
  has_attached_file :pic, 
                    :storage => :s3
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :bucket => 'natecui',
                    :default_style => :thumb,
                    :styles => {
                      :thumb  => "200x150#",
                      :thumb_b => "400x300#"
                    },
                    :url => "/system/template/:id/:style/:filename",
                    :path =>"/system/template/:id/:style/:filename"                    
  has_attached_file :back, 
                    :storage => :s3
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
                    :bucket => 'natecui',
                    :url => "/system/template/:id/back/:filename",
                    :path =>"/system/template/:id/:style/:filename"                  
end
