class Picture < ActiveRecord::Base
  belongs_to :user
  has_attached_file :photo, 
                    :default_style => :thumb,
                    :styles => {
                      :temp  => "240x150#"
                    },
                    :url => "/system/picture/:id/:style/:filename"
  scope :is_card, where(:is_card => '1')
                    
end
