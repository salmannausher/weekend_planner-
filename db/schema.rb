# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_03_13_090924) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "location"
    t.datetime "start_time"
    t.datetime "end_time"
    t.bigint "weekend_id", null: false
    t.string "suggested_by"
    t.decimal "cost"
    t.boolean "weather_dependent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["weekend_id"], name: "index_activities_on_weekend_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "weekend_id", null: false
    t.string "commenter_name"
    t.string "commenter_email"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["weekend_id"], name: "index_comments_on_weekend_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "name"
    t.string "google_token"
    t.string "google_refresh_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "activity_id", null: false
    t.string "voter_name"
    t.string "voter_email"
    t.string "vote_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_votes_on_activity_id"
  end

  create_table "weather_forecasts", force: :cascade do |t|
    t.bigint "weekend_id", null: false
    t.date "date"
    t.float "temperature"
    t.string "conditions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["weekend_id"], name: "index_weather_forecasts_on_weekend_id"
  end

  create_table "weekends", force: :cascade do |t|
    t.string "title"
    t.date "start_date"
    t.date "end_date"
    t.string "location"
    t.text "description"
    t.bigint "user_id", null: false
    t.string "share_token"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["share_token"], name: "index_weekends_on_share_token", unique: true
    t.index ["user_id"], name: "index_weekends_on_user_id"
  end

  add_foreign_key "activities", "weekends"
  add_foreign_key "comments", "weekends"
  add_foreign_key "votes", "activities"
  add_foreign_key "weather_forecasts", "weekends"
  add_foreign_key "weekends", "users"
end
