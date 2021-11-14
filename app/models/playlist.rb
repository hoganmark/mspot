class Playlist < ApplicationRecord
  belongs_to :user

  before_save :create_spotify_playlist

  def create_spotify_playlist
    self.uri = user.spotify_user.create_playlist!(name).uri
  end

  def spotify_playlist
    RSpotify::Playlist.find user.spotify_user.id, external_id
  end

  def external_id
    uri&.split(':')&.last
  end

  def name
    "my #{slug} playlist"
  end
end
