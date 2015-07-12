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

ActiveRecord::Schema.define(version: 20150710153426) do

  create_table "attendees", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.integer  "event_id"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reference_number"
    t.boolean  "confirmed",        default: false
    t.integer  "late_mails_sent"
    t.integer  "new_price",        default: 0
    t.date     "dob"
    t.string   "address"
    t.string   "town"
    t.string   "postnumber"
    t.string   "token"
  end

  add_index "attendees", ["event_id"], name: "index_attendees_on_event_id"
  add_index "attendees", ["school_id"], name: "index_attendees_on_school_id"

  create_table "events", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "form_sender_caches", force: true do |t|
    t.string   "address"
    t.datetime "expires"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mass_mails", force: true do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject"
    t.boolean  "sent"
  end

  create_table "schools", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "public",     default: false
  end

  create_table "sent_mass_mails", force: true do |t|
    t.integer  "attendee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mass_mail_id"
  end

  add_index "sent_mass_mails", ["attendee_id"], name: "index_sent_mass_mails_on_attendee_id"
  add_index "sent_mass_mails", ["mass_mail_id"], name: "index_sent_mass_mails_on_mass_mail_id"

end
