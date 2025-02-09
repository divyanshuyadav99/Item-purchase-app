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

ActiveRecord::Schema[7.0].define(version: 2024_09_24_172310) do
  create_table "order_items", force: :cascade do |t|
    t.integer "order_id", null: false
    t.string "sku_code"
    t.integer "quantity"
    t.integer "price"
    t.integer "total_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "order_number"
    t.integer "total_amount"
    t.string "delivery_zipcode"
    t.string "delivery_state"
    t.string "delivery_city"
    t.string "delivery_area"
    t.string "delivery_address"
    t.integer "tax"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prefecture_codes", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "ew_flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "souko_zaikos", force: :cascade do |t|
    t.string "warehouse_code"
    t.string "sku_code"
    t.string "stock_type"
    t.integer "stock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "order_items", "orders"
end
