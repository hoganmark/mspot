class Album < ApplicationRecord
  has_many :tracks, dependent: :destroy
  belongs_to :artist
  has_many :user_albums
  has_many :users, through: :user_albums

  serialize :available_markets, JSON

  scope :debut, -> { find_by(number: 1) }
  scope :sophomore, -> { find_by(number: 2) }
  scope :latest, -> { order(number: :desc).first }

  def spotify_album
    @spotify_album ||= RSpotify::Album.find(uri.split(':').last)
  end

  def fix_tracks!
    spotify_album.tracks(limit: 50).select{|track| track.artists.map(&:name).include?(artist.name)}.each do |spotify_track|
      next if tracks.exists?(uri: spotify_track.uri)

      audio_features = spotify_track.audio_features rescue nil
      tracks.create! \
        uri: spotify_track.uri,
        name: spotify_track.name,
        number: spotify_track.track_number,
        popularity: spotify_track.popularity,
        audio_features: audio_features,
        url: spotify_track.external_urls&.values&.first
    end
    true
  end
end
