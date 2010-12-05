class Picture < ActiveRecord::Base
  belongs_to :user
  has_attached_file :photo, :url => "/system/picture/:id/:style/:filename"
end
