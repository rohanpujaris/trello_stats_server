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

ActiveRecord::Schema.define(version: 20160214124513) do

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
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "current_sprint", default: false
    t.date     "start_date"
    t.date     "end_date"
  end

  add_foreign_key "card_members", "cards"
  add_foreign_key "card_members", "members"
  add_foreign_key "card_sprints", "cards"
  add_foreign_key "card_sprints", "sprints"
  add_foreign_key "cards", "lists"
  add_foreign_key "member_leaves", "members"
  add_foreign_key "point_stats", "members"
  add_foreign_key "point_stats", "sprints"
end
