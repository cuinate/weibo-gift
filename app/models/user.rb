class User < ActiveRecord::Base
   has_many :pictures
   has_many :friends
   attr_accessor :user_friends
   def user_friends=(val)
     @user_friends = val
   end
   
   def user_friends
     @user_friends
   end
end
