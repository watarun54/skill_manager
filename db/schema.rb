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

ActiveRecord::Schema.define(version: 2019_08_02_121354) do

  create_table "cards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "skill_id"
    t.integer "score"
    t.text "fact"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_id"], name: "index_cards_on_skill_id"
  end

  create_table "general_skills", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_general_skills_on_user_id"
  end

  create_table "papers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "status"
    t.text "url"
    t.bigint "user_id"
    t.bigint "general_skill_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["general_skill_id"], name: "index_papers_on_general_skill_id"
    t.index ["user_id"], name: "index_papers_on_user_id"
  end

  create_table "skills", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "general_skill_id"
    t.index ["general_skill_id"], name: "index_skills_on_general_skill_id"
    t.index ["user_id"], name: "index_skills_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 191, null: false
    t.string "email", limit: 191, null: false
    t.string "password_digest", limit: 191, null: false
    t.string "remember_token", limit: 191
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "skill_id"
    t.index ["skill_id"], name: "index_users_on_skill_id"
  end

  add_foreign_key "general_skills", "users"
  add_foreign_key "papers", "users"
  add_foreign_key "skills", "general_skills"
  add_foreign_key "skills", "users"
  add_foreign_key "users", "skills"
end
