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

ActiveRecord::Schema.define(version: 20180110123804) do

  create_table "branches", force: :cascade do |t|
    t.string "name"
    t.time "opening_time"
    t.time "closing_time"
    t.boolean "default_res", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "carts", force: :cascade do |t|
    t.integer "line_items_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string "body"
    t.integer "user_id"
    t.integer "inventory_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inventory_id"], name: "index_comments_on_inventory_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.boolean "category"
    t.boolean "extra_allowed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inventories", force: :cascade do |t|
    t.integer "branch_id"
    t.integer "ingredient_id"
    t.integer "quantity", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_inventories_on_branch_id"
    t.index ["ingredient_id"], name: "index_inventories_on_ingredient_id"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer "meal_id"
    t.integer "cart_id"
    t.integer "quantity", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "extra_ingredient"
    t.index ["cart_id"], name: "index_line_items_on_cart_id"
    t.index ["meal_id"], name: "index_line_items_on_meal_id"
  end

  create_table "meal_items", force: :cascade do |t|
    t.integer "meal_id"
    t.integer "ingredient_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_meal_items_on_ingredient_id"
    t.index ["meal_id"], name: "index_meal_items_on_meal_id"
  end

  create_table "meals", force: :cascade do |t|
    t.string "name"
    t.integer "price", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active"
    t.string "picture_file_name"
    t.string "picture_content_type"
    t.integer "picture_file_size"
    t.datetime "picture_updated_at"
  end

  create_table "orders", force: :cascade do |t|
    t.time "pick_up"
    t.string "phone_number"
    t.integer "cart_id"
    t.integer "user_id"
    t.integer "branch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_orders_on_branch_id"
    t.index ["cart_id"], name: "index_orders_on_cart_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "email_confirmed", default: false
    t.string "confirm_token"
    t.string "reset_digest"
    t.datetime "reset_password_sent_at"
    t.string "remember_digest"
    t.string "role", default: "customer"
  end

end
