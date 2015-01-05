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

ActiveRecord::Schema.define(version: 20150105090501) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: true do |t|
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

  create_table "memberships", force: true do |t|
    t.integer  "team_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["person_id"], name: "index_memberships_on_person_id", using: :btree
  add_index "memberships", ["team_id"], name: "index_memberships_on_team_id", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "organization_id"
    t.integer  "last_pair_id",    default: 0
    t.boolean  "paired",          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "people", ["organization_id"], name: "index_people_on_organization_id", using: :btree

  create_table "relationships", force: true do |t|
    t.integer  "partner1_id"
    t.integer  "partner2_id"
    t.integer  "week",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["partner1_id", "week"], name: "index_relationships_on_partner1_id_and_week", unique: true, using: :btree
  add_index "relationships", ["partner2_id", "week"], name: "index_relationships_on_partner2_id_and_week", unique: true, using: :btree

  create_table "teams", force: true do |t|
    t.string   "name"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["organization_id"], name: "index_teams_on_organization_id", using: :btree

end
