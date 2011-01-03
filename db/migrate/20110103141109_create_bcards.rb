class CreateBcards < ActiveRecord::Migration
  def self.up
    create_table :bcards do |t|
      t.string :name
      t.string :description
       # post-card:完成的效果图示
      t.string     :pic_file_name
      t.string     :pic_content_type
      t.integer    :pic_file_size

      t.timestamps
    end
  end

  def self.down
    drop_table :bcards
  end
end
