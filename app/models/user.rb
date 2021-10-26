class User < ApplicationRecord
  serialize :auth_hash, JSON

  has_many :user_artists
  has_many :artists, through: :user_artists

  def spotify_user
    @spotify_user ||= RSpotify::User.new(auth_hash)
  end

  def add_artist(name)
    spotify_artist = RSpotify::Artist.search(name).first
    raise 'artist not found' unless spotify_artist

    artist = Artist.find_or_create_by!(uri: spotify_artist.uri) do |a|
      a.name = spotify_artist.name
    end

    spotify_artist.genres.each do |genre|
      artist.genres.find_or_create_by! name: genre
    end

    user_artists.find_or_create_by!(artist: artist)

    spotify_artist.albums(limit: 50).select{|al| al.artists.map(&:name) == [artist.name]}.each do |spotify_album|
      next if artist.albums.exists? uri: spotify_album.uri

      album = artist.albums.create!(uri: spotify_album.uri) do |al|
        al.name = spotify_album.name
      end

      spotify_album.tracks(limit: 50).select{|track| track.artists.map(&:name).include?(artist.name)}.each do |spotify_track|
        album.tracks.create! \
          uri: spotify_track.uri,
          name: spotify_track.name
      end

    end

    artist
  end
end
