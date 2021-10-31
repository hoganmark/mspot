class User < ApplicationRecord
  serialize :auth_hash, JSON

  has_many :user_artists, dependent: :destroy
  has_many :artists, through: :user_artists
  has_many :user_albums, dependent: :destroy
  has_many :albums, through: :user_albums
  has_many :tracks, through: :albums

  def spotify_user
    @spotify_user ||= RSpotify::User.new(auth_hash)
  end

  def add_artist(name, sleep_after_album_s = 1)
    spotify_artist = RSpotify::Artist.search(name).first
    raise 'artist not found' unless spotify_artist

    artist = Artist.find_or_create_by!(uri: spotify_artist.uri) do |a|
      a.name = spotify_artist.name
    end

    spotify_artist.genres.each do |genre|
      genre = Genre.find_or_create_by! name: genre
      artist.artist_genres.find_or_create_by! genre: genre
    end

    user_artists.find_or_create_by!(artist: artist)

    spotify_artist.albums(limit: 50, album_type: :album).select{|al| al.artists.map(&:name) == [artist.name]}.each do |spotify_album|
      next if albums.exists? uri: spotify_album.uri
      next if albums.exists? artist_id: artist.id, name: spotify_album.name

      album = artist.albums.find_by uri: spotify_album.uri
      unless album
        album = artist.albums.create!(uri: spotify_album.uri) do |al|
          al.name = spotify_album.name
          al.year = spotify_album.release_date.split('-').first.to_i
          al.image = spotify_album.images.first['url'] if spotify_album.images&.first
          al.available_markets = spotify_album.available_markets
        end

        audio_features = spotify_track.audio_features rescue nil
        spotify_album.tracks(limit: 50).select{|track| track.artists.map(&:name).include?(artist.name)}.each do |spotify_track|
          album.tracks.create! \
            uri: spotify_track.uri,
            name: spotify_track.name,
            number: spotify_track.track_number,
            popularity: spotify_track.popularity,
            audio_features: audio_features,
            url: spotify_track.external_urls&.values&.first
        end
      end
      user_albums.create!(album: album) if album.available_markets.include? country

      sleep sleep_after_album_s
    end

    artist
  end

  def country
    auth_hash['country'] if auth_hash
  end
end
