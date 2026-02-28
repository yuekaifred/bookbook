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

ActiveRecord::Schema[8.1].define(version: 2026_02_25_211955) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "books", force: :cascade do |t|
    t.string "author", null: false
    t.string "cover_key"
    t.datetime "created_at", null: false
    t.string "display_author"
    t.string "display_title"
    t.integer "elo_score", default: 1000, null: false
    t.string "ol_work_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["ol_work_id"], name: "index_books_on_ol_work_id", unique: true
  end

  create_table "matches", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "loser_id", null: false
    t.datetime "updated_at", null: false
    t.integer "winner_id", null: false
    t.index ["loser_id"], name: "index_matches_on_loser_id"
    t.index ["winner_id"], name: "index_matches_on_winner_id"
  end

  add_foreign_key "matches", "books", column: "loser_id"
  add_foreign_key "matches", "books", column: "winner_id"
end
