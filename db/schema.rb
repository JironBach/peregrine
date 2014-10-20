# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141020183754) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "links", force: true do |t|
    t.string  "aff_url"
    t.string  "amzn_aff_url"
    t.string  "short_aff_url"
    t.string  "aff_url_clicks"
    t.integer "product_id"
  end

  add_index "links", ["product_id"], name: "index_links_on_product_id", using: :btree

  create_table "products", force: true do |t|
    t.integer "asin"
    t.string  "name"
    t.string  "amzn_url"
    t.string  "sm_img_url"
    t.string  "med_img_url"
    t.string  "lg_img_url"
    t.string  "reviews_url"
  end

  create_table "sales_ranks", force: true do |t|
    t.integer "rank"
    t.integer "product_id"
  end

  add_index "sales_ranks", ["product_id"], name: "index_sales_ranks_on_product_id", using: :btree

end
