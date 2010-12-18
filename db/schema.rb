# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101218124644) do

  create_table "pictures", :force => true do |t|
    t.integer  "user_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "is_card"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "templates", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "category"
    t.integer  "input_x"
    t.integer  "input_y"
    t.integer  "input_width"
    t.integer  "input_height"
    t.integer  "pic_x"
    t.integer  "pic_y"
    t.integer  "pic_width"
    t.integer  "pic_height"
    t.integer  "pic_angle"
    t.string   "pic_file_name"
    t.string   "pic_content_type"
    t.integer  "pic_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "weibo_id",          :null => false
    t.string   "screen_name"
    t.string   "token"
    t.string   "secret"
    t.string   "profile_image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["screen_name"], :name => "index_users_on_screen_name", :unique => true
  add_index "users", ["weibo_id"], :name => "index_users_on_weibo_id", :unique => true

end
