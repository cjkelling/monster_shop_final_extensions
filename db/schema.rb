ActiveRecord::Schema.define(version: 20190911214808) do

  enable_extension "plpgsql"

  create_table "item_orders", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "item_id"
    t.float "price"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.bigint "merchant_id"
    t.index ["item_id"], name: "index_item_orders_on_item_id"
    t.index ["merchant_id"], name: "index_item_orders_on_merchant_id"
    t.index ["order_id"], name: "index_item_orders_on_order_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "price"
    t.string "image", default: "https://thumbs.dreamstime.com/b/coming-soon-neon-sign-brick-wall-background-87865865.jpg"
    t.boolean "active?", default: true
    t.integer "inventory"
    t.bigint "merchant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id"], name: "index_items_on_merchant_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.integer "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enabled?", default: true
  end

  create_table "orders", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.integer "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "status", default: 0
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "title"
    t.string "content"
    t.integer "rating"
    t.bigint "item_id"
    t.index ["item_id"], name: "index_reviews_on_item_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.integer "zip"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.bigint "merchant_id"
    t.index ["merchant_id"], name: "index_users_on_merchant_id"
  end

  add_foreign_key "item_orders", "items"
  add_foreign_key "item_orders", "merchants"
  add_foreign_key "item_orders", "orders"
  add_foreign_key "items", "merchants"
  add_foreign_key "orders", "users"
  add_foreign_key "reviews", "items"
  add_foreign_key "users", "merchants"
end
