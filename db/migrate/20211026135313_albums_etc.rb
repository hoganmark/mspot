class AlbumsEtc < ActiveRecord::Migration[6.1]
  def up
    create_table :genres do |t|
      t.string :name

      t.timestamps
    end unless table_exists? :genres

    create_table :artist_genres do |t|
      t.references :artist
      t.references :genre

      t.timestamps
    end unless table_exists? :artist_genres

    create_table :artists do |t|
      t.string :name
      t.string :uri

      t.timestamps
    end unless table_exists? :artists

    create_table :user_artists do |t|
      t.references :user
      t.references :artist

      t.timestamps
    end unless table_exists? :user_artists

    create_table :albums do |t|
      t.string :name
      t.string :uri
      t.references :artist
      t.integer :year
      t.string :image

      t.timestamps
    end unless table_exists? :albums

    create_table :tracks do |t|
      t.string :name
      t.string :uri
      t.references :album

      t.timestamps
    end unless table_exists? :tracks
  end

  def down
    drop_table :tracks if table_exists? :tracks
    drop_table :albums if table_exists? :albums
    drop_table :user_artists if table_exists? :user_artists
    drop_table :artists if table_exists? :artists
    drop_table :artist_genres if table_exists? :artist_genres
    drop_table :genres if table_exists? :genres
  end
end
