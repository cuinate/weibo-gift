class User < ActiveRecord::Base
   has_many :pictures
   attr_accessor :user_friends
   def user_friends=(val)
     @user_friends = val
   end
   
   def user_friends
     @user_friends
   end
end
