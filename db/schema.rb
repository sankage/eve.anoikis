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

ActiveRecord::Schema.define(version: 20160816005422) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "connection_statuses", force: :cascade do |t|
    t.integer  "mass",       default: 0
    t.integer  "life",       default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "connections", force: :cascade do |t|
    t.integer  "signature_id"
    t.integer  "matched_signature_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "wh_type"
    t.integer  "connection_status_id"
    t.index ["connection_status_id"], name: "index_connections_on_connection_status_id", using: :btree
    t.index ["matched_signature_id"], name: "index_connections_on_matched_signature_id", using: :btree
    t.index ["signature_id", "matched_signature_id"], name: "index_connections_on_signature_id_and_matched_signature_id", unique: true, using: :btree
    t.index ["signature_id"], name: "index_connections_on_signature_id", using: :btree
  end

  create_table "notes", force: :cascade do |t|
    t.text     "text"
    t.integer  "solar_system_id"
    t.integer  "pilot_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["pilot_id"], name: "index_notes_on_pilot_id", using: :btree
    t.index ["solar_system_id"], name: "index_notes_on_solar_system_id", using: :btree
  end

  create_table "pilots", force: :cascade do |t|
    t.integer  "character_id"
    t.string   "name"
    t.string   "token"
    t.string   "refresh_token"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "admin",         default: false
  end

  create_table "signatures", force: :cascade do |t|
    t.integer  "solar_system_id"
    t.string   "sig_id"
    t.integer  "type"
    t.integer  "group"
    t.string   "name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["solar_system_id"], name: "index_signatures_on_solar_system_id", using: :btree
  end

  create_table "solar_systems", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "wormhole_class"
    t.string   "region"
    t.string   "constellation"
    t.string   "effect"
    t.decimal  "security",            precision: 2, scale: 1
    t.integer  "distance_to_jita"
    t.integer  "distance_to_amarr"
    t.integer  "distance_to_dodixie"
    t.integer  "distance_to_rens"
    t.integer  "distance_to_hek"
    t.integer  "distance_to_stacmon"
  end

  create_table "statics", force: :cascade do |t|
    t.integer  "solar_system_id"
    t.integer  "wormhole_type_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["solar_system_id"], name: "index_statics_on_solar_system_id", using: :btree
    t.index ["wormhole_type_id"], name: "index_statics_on_wormhole_type_id", using: :btree
  end

  create_table "tabs", force: :cascade do |t|
    t.string   "name"
    t.boolean  "active",          default: false
    t.integer  "solar_system_id"
    t.integer  "pilot_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["pilot_id"], name: "index_tabs_on_pilot_id", using: :btree
    t.index ["solar_system_id"], name: "index_tabs_on_solar_system_id", using: :btree
  end

  create_table "wormhole_types", force: :cascade do |t|
    t.string   "name"
    t.bigint   "mass_total"
    t.integer  "mass_jump"
    t.integer  "mass_regen"
    t.string   "leads_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "connections", "connection_statuses"
  add_foreign_key "connections", "signatures"
  add_foreign_key "connections", "signatures", column: "matched_signature_id"
  add_foreign_key "notes", "pilots"
  add_foreign_key "notes", "solar_systems"
  add_foreign_key "signatures", "solar_systems"
  add_foreign_key "statics", "solar_systems"
  add_foreign_key "statics", "wormhole_types"
  add_foreign_key "tabs", "pilots"
  add_foreign_key "tabs", "solar_systems"
end
