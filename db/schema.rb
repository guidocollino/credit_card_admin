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

ActiveRecord::Schema.define(version: 20150610154300) do

  create_table "reason_of_uses", force: true do |t|
    t.string   "name"
    t.integer  "priority"
    t.string   "description"
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "to_use_credit_cards", force: true do |t|
    t.string   "number"
    t.string   "expiration_month"
    t.string   "expiration_year"
    t.string   "security_code"
    t.string   "holder"
    t.float    "amount",             limit: 24
    t.integer  "quotes"
    t.integer  "load_file"
    t.date     "date_limit"
    t.boolean  "allows_partial_use",            default: false
    t.string   "clarification"
    t.string   "email"
    t.string   "authorization_code"
    t.boolean  "blocked",                       default: false
    t.boolean  "partial_used",                  default: false
    t.boolean  "used",                          default: false
    t.boolean  "disabled",                      default: false
    t.integer  "creator_id"
    t.string   "creator_name"
    t.integer  "taker_id"
    t.integer  "agency_id"
    t.string   "consumer"
    t.integer  "bank_id"
    t.string   "bank_mongodb_id"
    t.integer  "credit_card_id"
    t.string   "card_mongodb_id"
    t.integer  "reason_id"
    t.string   "mongo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "use_data", force: true do |t|
    t.integer  "to_use_credit_card_id"
    t.float    "amount",                 limit: 24
    t.integer  "user_id"
    t.string   "user_name"
    t.integer  "used_file"
    t.date     "used_date"
    t.integer  "es_sale_id"
    t.boolean  "cancel",                            default: false
    t.string   "mongo_id"
    t.string   "credit_card_mongodb_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "use_data", ["to_use_credit_card_id"], name: "index_use_data_on_to_use_credit_card_id", using: :btree

end
