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

ActiveRecord::Schema.define(version: 2021_10_26_192416) do

  create_table "albums", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "uri"
    t.bigint "artist_id"
    t.integer "year"
    t.string "image"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["artist_id"], name: "index_albums_on_artist_id"
  end

  create_table "artist_genres", charset: "utf8", force: :cascade do |t|
    t.bigint "artist_id"
    t.bigint "genre_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["artist_id"], name: "index_artist_genres_on_artist_id"
    t.index ["genre_id"], name: "index_artist_genres_on_genre_id"
  end

  create_table "artists", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "uri"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "genres", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tracks", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "uri"
    t.bigint "album_id"
    t.text "audio_features"
    t.integer "tempo"
    t.boolean "acoustic"
    t.integer "duration"
    t.integer "mode", limit: 1
    t.string "key"
    t.integer "time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "number"
    t.index ["album_id"], name: "index_tracks_on_album_id"
  end

  create_table "user_artists", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "artist_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["artist_id"], name: "index_user_artists_on_artist_id"
    t.index ["user_id"], name: "index_user_artists_on_user_id"
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.text "auth_hash"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
    t.string "userid"
  end

end
