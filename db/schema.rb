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

ActiveRecord::Schema.define(version: 20170509041415) do

  create_table "charges", force: :cascade do |t|
    t.string   "email"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.string   "date"
    t.time     "time"
    t.string   "location"
    t.integer  "user_id"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.decimal  "price",               precision: 10, scale: 2
    t.integer  "attendees"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "parties", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "rating"
    t.string   "comment"
    t.boolean  "attended"
    t.index ["event_id"], name: "index_parties_on_event_id"
    t.index ["user_id"], name: "index_parties_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "email"
    t.text     "bio"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",           default: false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "customer_id"
    t.string   "account_id"
    t.integer  "radius"
    t.boolean  "card_avail"
    t.integer  "passcode"
    t.string   "dob"
    t.boolean  "verify"
    t.boolean  "offender"
  end

end
