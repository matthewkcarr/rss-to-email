# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090225035525) do

  create_table "posts", :force => true do |t|
    t.integer  "site_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["site_id"], :name => "index_posts_on_site_id"

  create_table "preferences", :force => true do |t|
    t.integer  "user_id",      :null => false
    t.integer  "site_id",      :null => false
    t.string   "keywords"
    t.integer  "throttle"
    t.boolean  "twitter_only"
    t.boolean  "twitter_self"
    t.boolean  "twitter_all"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "preferences", ["site_id", "user_id"], :name => "index_preferences_on_site_id_and_user_id"
  add_index "preferences", ["user_id", "site_id"], :name => "index_preferences_on_user_id_and_site_id"

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sites", ["name"], :name => "index_sites_on_name", :unique => true

  create_table "sites_users", :force => true do |t|
    t.integer "user_id"
    t.integer "site_id"
  end

  add_index "sites_users", ["site_id", "user_id"], :name => "index_sites_users_on_site_id_and_user_id"
  add_index "sites_users", ["user_id", "site_id"], :name => "index_sites_users_on_user_id_and_site_id"

  create_table "twitter_configs", :force => true do |t|
    t.integer  "user_id"
    t.string   "twitter_username"
    t.string   "twitter_password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "twitter_configs", ["user_id"], :name => "index_twitter_configs_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                    :default => "passive"
    t.datetime "deleted_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
