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

ActiveRecord::Schema[7.0].define(version: 2023_01_06_223857) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "category_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_group_id"], name: "index_categories_on_category_group_id"
  end

  create_table "category_groups", force: :cascade do |t|
    t.string "title", null: false
    t.string "category_type", null: false
    t.string "color", default: ""
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_category_groups_on_user_id"
  end

  create_table "earnings", force: :cascade do |t|
    t.string "name", null: false
    t.float "amount", null: false
    t.date "date", null: false
    t.bigint "category_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_earnings_on_category_id"
    t.index ["user_id"], name: "index_earnings_on_user_id"
  end

  create_table "expenses", force: :cascade do |t|
    t.string "name", null: false
    t.float "amount", null: false
    t.bigint "first_installment_id"
    t.integer "installments_number", default: 1, null: false
    t.date "date", null: false
    t.date "payment_date", null: false
    t.bigint "user_id"
    t.bigint "category_id"
    t.bigint "payment_method_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_expenses_on_category_id"
    t.index ["payment_method_id"], name: "index_expenses_on_payment_method_id"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_payment_methods_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "password_digest"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_token"
  end

  add_foreign_key "categories", "category_groups"
  add_foreign_key "category_groups", "users"
  add_foreign_key "earnings", "categories"
  add_foreign_key "earnings", "users"
  add_foreign_key "expenses", "categories"
  add_foreign_key "expenses", "payment_methods"
  add_foreign_key "expenses", "users"
  add_foreign_key "payment_methods", "users"
end
