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

ActiveRecord::Schema.define(version: 20150504224557) do

  create_table "event_images", force: :cascade do |t|
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "event_id"
  end

  add_index "event_images", ["event_id"], name: "index_event_images_on_event_id"

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.string   "location"
    t.string   "description"
    t.string   "startTime"
    t.string   "endTime"
    t.string   "imageUrl"
    t.string   "organization"
    t.string   "type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "user_id"
    t.boolean  "publicEvent"
  end

  add_index "events", ["user_id"], name: "index_events_on_user_id"

  create_table "invitees", force: :cascade do |t|
    t.string   "email"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "event_id"
  end

  add_index "invitees", ["event_id"], name: "index_invitees_on_event_id"

  create_table "registration_ids", force: :cascade do |t|
    t.string   "regid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "registration_ids", ["user_id"], name: "index_registration_ids_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "password"
  end

end
