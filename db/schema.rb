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

ActiveRecord::Schema.define(version: 20160309132958) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "card_members", force: :cascade do |t|
    t.integer  "card_id"
    t.integer  "member_id"
    t.integer  "individuals_point"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "card_members", ["card_id"], name: "index_card_members_on_card_id", using: :btree
  add_index "card_members", ["member_id"], name: "index_card_members_on_member_id", using: :btree

  create_table "card_sprints", force: :cascade do |t|
    t.integer  "card_id"
    t.integer  "sprint_id"
    t.string   "individual_sprint_points"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "card_sprints", ["card_id"], name: "index_card_sprints_on_card_id", using: :btree
  add_index "card_sprints", ["sprint_id"], name: "index_card_sprints_on_sprint_id", using: :btree

  create_table "cards", force: :cascade do |t|
    t.text     "name"
    t.string   "trello_id"
    t.integer  "points"
    t.integer  "list_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "sprint_id"
    t.integer  "point_expecctation"
    t.boolean  "points_manuallly_assigned", default: false
  end

  add_index "cards", ["list_id"], name: "index_cards_on_list_id", using: :btree
  add_index "cards", ["sprint_id"], name: "index_cards_on_sprint_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "holidays", force: :cascade do |t|
    t.string "name"
    t.date   "date"
  end

  create_table "lists", force: :cascade do |t|
    t.string   "name"
    t.integer  "category_cd"
    t.string   "trello_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "member_leaves", force: :cascade do |t|
    t.integer "member_id"
    t.date    "date"
  end

  add_index "member_leaves", ["member_id"], name: "index_member_leaves_on_member_id", using: :btree

  create_table "member_sprint_leaves", force: :cascade do |t|
    t.integer "sprint_id"
    t.integer "member_id"
    t.date    "leave_date"
  end

  add_index "member_sprint_leaves", ["member_id"], name: "index_member_sprint_leaves_on_member_id", using: :btree
  add_index "member_sprint_leaves", ["sprint_id"], name: "index_member_sprint_leaves_on_sprint_id", using: :btree

  create_table "members", force: :cascade do |t|
    t.string   "full_name"
    t.string   "user_name"
    t.string   "trello_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "job_profile_cd"
    t.integer  "expected_points"
  end

  create_table "point_stats", force: :cascade do |t|
    t.integer  "member_id"
    t.integer  "sprint_id"
    t.string   "doing"
    t.string   "in_qa"
    t.string   "qa_passed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "point_stats", ["member_id"], name: "index_point_stats_on_member_id", using: :btree
  add_index "point_stats", ["sprint_id"], name: "index_point_stats_on_sprint_id", using: :btree

  create_table "sprints", force: :cascade do |t|
    t.string   "name"
    t.string   "trello_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date     "start_date"
    t.date     "end_date"
  end

  create_table "sync_records", force: :cascade do |t|
    t.time     "synced_time"
    t.integer  "user_id"
    t.integer  "category_cd", default: 0
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "sync_records", ["user_id"], name: "index_sync_records_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "email"
    t.json     "tokens"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "member_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["member_id"], name: "index_users_on_member_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  add_foreign_key "card_members", "cards"
  add_foreign_key "card_members", "members"
  add_foreign_key "card_sprints", "cards"
  add_foreign_key "card_sprints", "sprints"
  add_foreign_key "cards", "lists"
  add_foreign_key "member_leaves", "members"
  add_foreign_key "member_sprint_leaves", "members"
  add_foreign_key "member_sprint_leaves", "sprints"
  add_foreign_key "point_stats", "members"
  add_foreign_key "point_stats", "sprints"
  add_foreign_key "sync_records", "users"
end
