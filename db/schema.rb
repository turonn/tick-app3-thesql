# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_03_163330) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.string "sport"
    t.string "gender"
    t.string "level"
    t.bigint "home_team_id", null: false
    t.bigint "visiting_team_id", null: false
    t.string "location"
    t.integer "max_capacity"
    t.datetime "event_start"
    t.integer "price"
    t.index ["home_team_id"], name: "index_games_on_home_team_id"
    t.index ["visiting_team_id"], name: "index_games_on_visiting_team_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.string "mascot"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "phone"
    t.string "logo_location"
  end

  create_table "tickets", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "user_id"
    t.boolean "used"
    t.string "ticket_code"
    t.index ["game_id"], name: "index_tickets_on_game_id"
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.bigint "home_team_id", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["home_team_id"], name: "index_users_on_home_team_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "games", "schools", column: "home_team_id"
  add_foreign_key "games", "schools", column: "visiting_team_id"
  add_foreign_key "users", "schools", column: "home_team_id"
end
