# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20120228155915) do

  create_table "friendships", :force => true do |t|
    t.integer  "owner_id",   :null => false
    t.integer  "friend_id",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "friendships", ["friend_id"], :name => "index_friendships_on_friend_id"
  add_index "friendships", ["owner_id"], :name => "index_friendships_on_owner_id"

  create_table "pings", :force => true do |t|
    t.integer  "user_id"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "source"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "facebook_id"
  end

  add_index "pings", ["facebook_id"], :name => "index_pings_on_facebook_id"
  add_index "pings", ["user_id"], :name => "index_pings_on_user_id"

  create_table "users", :force => true do |t|
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "twitter_user_id"
    t.string   "facebook_user_id"
    t.string   "image_url"
    t.string   "authentication_token"
    t.text     "credentials"
    t.string   "name"
  end

end
