class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.integer :user_id
      t.string  :photo_file_name
      t.string  :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      t.integer  :is_card
      t.timestamps
    end
  end

  def self.down
    drop_table :pictures
  end
end
