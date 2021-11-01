require 'csv'

class Artist < ApplicationRecord
  has_many :albums, dependent: :destroy
  has_many :artist_genres, dependent: :destroy
  has_many :genres, through: :artist_genres
  has_many :user_artists, dependent: :destroy
  has_many :users, through: :user_artists

  def spotify_artist
    @spotify_artist ||= RSpotify::Artist.find(uri.split(':').last)
  end

  def fix_tracks!
    albums.each {|album| album.fix_tracks!}
    true
  end
end
