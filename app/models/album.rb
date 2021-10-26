class Album < ApplicationRecord
  has_many :tracks, dependent: :destroy
  belongs_to :artist

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
        audio_features: audio_features
    end
    true
  end
end
