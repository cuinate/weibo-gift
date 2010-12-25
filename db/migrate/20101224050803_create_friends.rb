class CreateFriends < ActiveRecord::Migration
  def self.up
    create_table :friends do |t|
      t.column  :weibo_id, :bigint, :null => false
			t.string  :screen_name
			t.string  :profile_image_url
			t.integer :user_id

      t.timestamps
    end
    	add_index :friends, :weibo_id, :unique => true
  end

  def self.down
    remove_index :friends, :weibo_id
    drop_table :friends
  end
end
