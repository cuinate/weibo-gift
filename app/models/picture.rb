class Picture < ActiveRecord::Base
  belongs_to :user
  has_attached_file :photo, 
                    :storage => :s3,
                    :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", 
                    :bucket => 'natecui',
                    :default_style => :card280,
                    :styles => {
                      :card480  => "480x360#",
                      :card400  => "400x300#",                      
                      :card280  => "280x210#",                    
                    },
                    :url => "/system/picture/:id/:style/:filename",
                    :path =>"/system/picture/:id/:style/:filename"
  scope :is_card, where(:is_card => '1')
                    
end
