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

ActiveRecord::Schema.define(version: 2014_10_22_211937) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "links", id: :serial, force: :cascade do |t|
    t.string "asin"
    t.string "name"
    t.string "amzn_url"
    t.string "aff_tag"
    t.string "sm_img_url"
    t.string "med_img_url"
    t.string "lg_img_url"
    t.string "reviews_url"
    t.string "amzn_aff_url"
    t.string "short_aff_url"
    t.string "aff_url_clicks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "sales_rank"
    t.integer "user_id"
    t.index ["user_id"], name: "index_links_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "aff_tag"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
