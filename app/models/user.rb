class User < ActiveRecord::Base
   has_many :pictures
   attr_accessor :user_friends
   
   def friend_ids=(val)
     self[:user_friends] = val
   end
   
   def friend_ids
     self[:user_friends]
   end
end
