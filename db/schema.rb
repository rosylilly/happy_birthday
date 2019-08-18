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

ActiveRecord::Schema.define(version: 2019_08_18_094610) do

  create_table "characters", force: :cascade do |t|
    t.integer "work_id", null: false
    t.string "name", limit: 255, null: false
    t.string "name_kana", limit: 255, null: false
    t.integer "birth_month", limit: 2, null: false
    t.integer "birth_day", limit: 2, null: false
    t.integer "gender", limit: 1, default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["work_id"], name: "index_characters_on_work_id"
  end

  create_table "works", force: :cascade do |t|
    t.string "title", limit: 255, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["title"], name: "index_works_on_title", unique: true
  end

  add_foreign_key "characters", "works"
end
