class Artist < ApplicationRecord
  has_many :albums
  has_many :artist_genres
  has_many :genres, through: :artist_genres
  has_many :user_artists
  has_many :users, through: :user_artists
end
