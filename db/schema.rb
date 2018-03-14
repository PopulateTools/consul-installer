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

ActiveRecord::Schema.define(version: 20170523084112) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
    t.index ["associated_id", "associated_type"], name: "associated_index", using: :btree
    t.index ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
    t.index ["created_at"], name: "index_audits_on_created_at", using: :btree
    t.index ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
    t.index ["user_id", "user_type"], name: "user_index", using: :btree
  end

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
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "server_setups", force: :cascade do |t|
    t.integer  "server_id"
    t.string   "status"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string   "return_value"
    t.text     "log"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["server_id"], name: "index_server_setups_on_server_id", using: :btree
  end

  create_table "servers", force: :cascade do |t|
    t.string   "name"
    t.string   "ip"
    t.string   "server_type"
    t.string   "status",      default: "new"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["name"], name: "index_servers_on_name", unique: true, using: :btree
  end

  create_table "site_deploys", force: :cascade do |t|
    t.integer  "site_id"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string   "status"
    t.text     "log"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["site_id"], name: "index_site_deploys_on_site_id", using: :btree
  end

  create_table "site_setups", force: :cascade do |t|
    t.integer  "site_id"
    t.string   "status"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string   "return_value"
    t.text     "log"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["site_id"], name: "index_site_setups_on_site_id", using: :btree
  end

  create_table "sites", force: :cascade do |t|
    t.string   "name"
    t.string   "host"
    t.string   "base_path"
    t.string   "db_name"
    t.string   "db_user"
    t.string   "db_password"
    t.string   "rails_env"
    t.string   "secret_key_base"
    t.integer  "web_server_id"
    t.integer  "app_server_id"
    t.integer  "db_server_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "repo_url"
    t.boolean  "httpauth_protected", default: true
    t.string   "census_api_username"
    t.string   "census_api_password"
    t.string   "census_api_token_host"
    t.string   "census_api_endpoint"
    t.index ["base_path"], name: "index_sites_on_base_path", unique: true, using: :btree
    t.index ["db_name"], name: "index_sites_on_db_name", unique: true, using: :btree
    t.index ["name"], name: "index_sites_on_name", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.boolean  "admin"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "server_setups", "servers"
  add_foreign_key "site_deploys", "sites"
  add_foreign_key "site_setups", "sites"
end
