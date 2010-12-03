class CreateUsers < ActiveRecord::Migration
  def self.up
    	create_table :users do |t|
  			t.column :weibo_id, :bigint, :null => false
  			t.string :screen_name
  			t.string :token
  			t.string :secret
  			t.string :profile_image_url
  			t.timestamps
  		end
  		add_index :users, :weibo_id, :unique => true
  		add_index :users, :screen_name, :unique => true
  	end

  	def self.down
  		remove_index :users, :weibo_id
  		remove_index :users, :screen_name
  		drop_table :users
  	end
end
