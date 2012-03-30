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

ActiveRecord::Schema.define(:version => 20100323204630) do

  create_table "account_couponcodes", :force => true do |t|
    t.string   "couponcode"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "account_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "account_id"
    t.string   "role",         :limit => 15, :default => "User"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_token"
    t.datetime "processed_at"
    t.datetime "errored_at"
  end

  add_index "account_users", ["user_id", "account_id"], :name => "account_user_u1", :unique => true

  create_table "accounts", :force => true do |t|
    t.integer  "payment_id"
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "org_name",                                         :null => false
    t.string   "backpack_sitename"
    t.date     "next_bill_date"
    t.decimal  "bill_amount",       :precision => 10, :scale => 2
    t.boolean  "is_canceled"
    t.boolean  "ssl_required"
  end

  create_table "backpack_reminders", :force => true do |t|
    t.integer  "calendar_id"
    t.integer  "calendar_event_id"
    t.integer  "reminder_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "event_updated_at"
    t.integer  "account_user_id"
  end

  create_table "mailinglists", :force => true do |t|
    t.string   "email_address", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mailinglists", ["email_address"], :name => "email_address", :unique => true

  create_table "payments", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.binary   "number"
    t.binary   "number_key"
    t.binary   "number_iv"
    t.binary   "cvv_number"
    t.binary   "cvv_number_key"
    t.binary   "cvv_number_iv"
    t.integer  "exp_month",      :limit => 2
    t.integer  "exp_year",       :limit => 2, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", :force => true do |t|
    t.string   "name"
    t.decimal  "price",           :precision => 10, :scale => 2
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "users_allowed"
    t.integer  "update_interval"
  end

  create_table "selectvalues", :force => true do |t|
    t.string "value",  :default => "\"\""
    t.string "value2"
    t.string "key",    :default => "\"\""
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "hashed_password"
    t.string   "salt",            :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "timezone"
  end

end
