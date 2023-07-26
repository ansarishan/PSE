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

ActiveRecord::Schema[7.0].define(version: 2020_07_06_212351) do
  create_table "addresses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "line1"
    t.string "line2"
    t.string "city", null: false
    t.string "state"
    t.string "postcode"
    t.string "country", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "drug_companies", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "drug_instruments", force: :cascade do |t|
    t.integer "drug_period_id", null: false
    t.integer "up_leverage_factor", null: false
    t.integer "down_leverage_factor", null: false
    t.integer "up_return_cap", null: false
    t.integer "down_return_cap", null: false
    t.decimal "net_revenue_projection", precision: 17, scale: 5, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "label"
    t.string "source"
    t.index ["drug_period_id"], name: "index_drug_instruments_on_drug_period_id"
  end

  create_table "drug_periods", force: :cascade do |t|
    t.integer "drug_id", null: false
    t.string "label", null: false
    t.string "period_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "trailing_period_date_range"
    t.string "prediction_period_date_range"
    t.decimal "net_revenue_actual", precision: 17, scale: 5
    t.integer "status", default: 0, null: false
    t.integer "region_id", null: false
    t.index ["drug_id"], name: "index_drug_periods_on_drug_id"
    t.index ["region_id"], name: "index_drug_periods_on_region_id"
  end

  create_table "drugs", force: :cascade do |t|
    t.string "brand_name", null: false
    t.integer "drug_company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "compound_name"
    t.string "generic_name"
    t.index ["drug_company_id"], name: "index_drugs_on_drug_company_id"
  end

  create_table "onboarding_invites", force: :cascade do |t|
    t.string "url_code", null: false
    t.string "email", null: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_onboarding_invites_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "regions", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tradables", force: :cascade do |t|
    t.integer "amount"
    t.integer "state", default: 0
    t.integer "drug_instrument_id", null: false
    t.integer "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "side", default: 0, null: false
    t.integer "trade_id"
    t.string "type", default: "Order"
    t.integer "counter_order_id"
    t.index ["drug_instrument_id"], name: "index_tradables_on_drug_instrument_id"
    t.index ["organization_id"], name: "index_tradables_on_organization_id"
    t.index ["trade_id"], name: "index_tradables_on_trade_id"
  end

  create_table "trades", force: :cascade do |t|
    t.integer "state", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "upside_gain", precision: 17, scale: 5
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.boolean "has_signed_eula", default: false, null: false
    t.boolean "onboarded", default: false, null: false
    t.integer "role", null: false
    t.integer "organization_id"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.boolean "legal_is_separate", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "addresses", "users"
  add_foreign_key "drug_instruments", "drug_periods"
  add_foreign_key "drug_periods", "drugs"
  add_foreign_key "drug_periods", "regions"
  add_foreign_key "onboarding_invites", "users"
  add_foreign_key "tradables", "drug_instruments"
  add_foreign_key "tradables", "organizations"
  add_foreign_key "tradables", "trades"
end
