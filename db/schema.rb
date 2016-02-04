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

ActiveRecord::Schema.define(version: 20160204203333) do

  create_table "card_members", force: :cascade do |t|
    t.integer  "card_id"
    t.integer  "member_id"
    t.integer  "individuals_point"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "card_members", ["card_id"], name: "index_card_members_on_card_id"
  add_index "card_members", ["member_id"], name: "index_card_members_on_member_id"

  create_table "card_sprints", force: :cascade do |t|
    t.integer  "card_id"
    t.integer  "sprint_id"
    t.string   "individual_sprint_points"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "card_sprints", ["card_id"], name: "index_card_sprints_on_card_id"
  add_index "card_sprints", ["sprint_id"], name: "index_card_sprints_on_sprint_id"

  create_table "cards", force: :cascade do |t|
    t.text     "name"
    t.string   "trello_id"
    t.integer  "points"
    t.integer  "list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "cards", ["list_id"], name: "index_cards_on_list_id"

  create_table "lists", force: :cascade do |t|
    t.string   "name"
    t.string   "category"
    t.string   "trello_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", force: :cascade do |t|
    t.string   "full_name"
    t.string   "user_name"
    t.string   "trello_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_index "point_stats", ["member_id"], name: "index_point_stats_on_member_id"
  add_index "point_stats", ["sprint_id"], name: "index_point_stats_on_sprint_id"

  create_table "sprints", force: :cascade do |t|
    t.string   "name"
    t.string   "trello_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
