class CreateTemplates < ActiveRecord::Migration
  def self.up
    create_table :templates do |t|
      t.string     :name
      t.string     :description
      t.string     :category
      t.integer    :input_x
      t.integer    :input_y
      t.integer    :input_width
      t.integer    :input_height
      t.integer    :pic_x
      t.integer    :pic_y
      t.integer    :pic_width
      t.integer    :pic_height
      t.integer    :pic_angle
      # post-card:完成的效果图示
      t.string     :pic_file_name
      t.string     :pic_content_type
      t.integer    :pic_file_size
      # 对于‘宝丽来’的card来说，这个back是白框，对于post-card来说，这个是明信片的背景图
      t.string     :back_file_name
      t.string     :back_content_type
      t.integer    :back_file_size
      
      t.string     :frame_file_name
      t.string     :frame_content_type
      t.integer    :frame_file_size
      t.timestamps
    end
  end

  def self.down
    drop_table :templates
  end
end
