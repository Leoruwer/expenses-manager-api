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

ActiveRecord::Schema[7.0].define(version: 2023_02_17_192755) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["name", "user_id"], name: "user_id_accounts_name_index", unique: true
    t.index ["slug", "user_id"], name: "user_id_accounts_slug_index", unique: true
    t.index ["slug"], name: "index_accounts_on_slug"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["name", "user_id"], name: "user_id_categories_name_index", unique: true
    t.index ["slug", "user_id"], name: "user_id_categories_slug_index", unique: true
    t.index ["slug"], name: "index_categories_on_slug"
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "default_bills", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.integer "value_in_cents", default: 0, null: false
    t.string "value_currency", default: "BRL", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["name", "user_id"], name: "user_id_default_bills_name_index", unique: true
    t.index ["slug", "user_id"], name: "user_id_default_bills_slug_index", unique: true
    t.index ["slug"], name: "index_default_bills_on_slug"
    t.index ["user_id"], name: "index_default_bills_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.integer "value_in_cents", default: 0, null: false
    t.string "value_currency", default: "BRL", null: false
    t.datetime "due_at", null: false
    t.datetime "paid_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "account_id", null: false
    t.bigint "category_id", null: false
    t.index ["account_id"], name: "index_expenses_on_account_id"
    t.index ["category_id"], name: "index_expenses_on_category_id"
    t.index ["name", "user_id"], name: "user_id_expenses_name_index", unique: true
    t.index ["slug", "user_id"], name: "user_id_expenses_slug_index", unique: true
    t.index ["slug"], name: "index_expenses_on_slug"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "slug", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["slug"], name: "user_slug_index", unique: true
  end

end
