class Artist < ApplicationRecord
  has_many :albums, dependent: :destroy
  has_many :artist_genres, dependent: :destroy
  has_many :genres, through: :artist_genres
  has_many :user_artists, dependent: :destroy
  has_many :users, through: :user_artists
end
