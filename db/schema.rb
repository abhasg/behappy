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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150829143209) do

  create_table "fb_images", force: :cascade do |t|
    t.integer  "fb_id",            limit: 8
    t.integer  "from",             limit: 8
    t.string   "from_name",        limit: 255
    t.datetime "photo_created_at"
    t.text     "images",           limit: 65535
    t.text     "picture",          limit: 65535
    t.integer  "place_id",         limit: 8
    t.string   "place_name",       limit: 255
    t.text     "place_location",   limit: 65535
    t.text     "source",           limit: 65535
    t.integer  "original_height",  limit: 4
    t.integer  "original_width",   limit: 4
    t.text     "tags",             limit: 65535
    t.text     "comments",         limit: 65535
    t.text     "links",            limit: 65535
    t.integer  "user_id",          limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "images", force: :cascade do |t|
    t.integer  "imageable_id",        limit: 4
    t.string   "imageable_type",      limit: 255
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size",    limit: 4
    t.datetime "avatar_updated_at"
  end

  add_index "images", ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id", using: :btree

  create_table "user_details", force: :cascade do |t|
    t.integer  "user_id",            limit: 4
    t.integer  "imageable_id",       limit: 4
    t.string   "imageable_type",     limit: 255
    t.integer  "absolute_happy_q",   limit: 4
    t.integer  "calculated_happy_q", limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                           limit: 255,   default: "", null: false
    t.string   "encrypted_password",              limit: 255,   default: "", null: false
    t.string   "reset_password_token",            limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                   limit: 4,     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",              limit: 255
    t.string   "last_sign_in_ip",                 limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authentication_token",            limit: 255
    t.datetime "authentication_token_valid_till"
    t.text     "fb_token",                        limit: 65535
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
