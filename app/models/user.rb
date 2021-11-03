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
      upc = spotify_album.external_ids&.dig('upc')&.to_i&.to_s # remove leading zeros
      next if upc && albums.exists?(upc: upc)
      next if albums.exists? artist_id: artist.id, name: spotify_album.name
      next unless spotify_album.available_markets.include? country
      next if spotify_album.album_type == 'compilation' # still getting some despite query for some reason
      next if RSpotify::Album.find(spotify_album.id).inspect.downcase['compilation']
      tracks = spotify_album.tracks(limit: 50).select{|track| track.artists.map(&:name).include?(artist.name)}
      next if tracks.size < 6 # LPs only please
      next if upc.in? Album.ignored_upcs

      album = artist.albums.find_by uri: spotify_album.uri
      unless album
        album = artist.albums.create!(uri: spotify_album.uri) do |al|
          al.name = spotify_album.name
          al.year = spotify_album.release_date.split('-').first.to_i
          al.image = spotify_album.images.first['url'] if spotify_album.images&.first
          al.available_markets = spotify_album.available_markets
          al.upc = upc
        end

        tracks.each do |spotify_track|
          audio_features = spotify_track.audio_features rescue nil
          album.tracks.create! \
            uri: spotify_track.uri,
            name: spotify_track.name,
            number: spotify_track.track_number,
            popularity: spotify_track.popularity,
            audio_features: audio_features,
            url: spotify_track.external_urls&.values&.first
        end

        corrected_year = Album.corrected_years[spotify_album.id]
        album.update! year: corrected_year if corrected_year

        if (album.tracks.map{|t| t.audio_features&.dig('liveness')}.sum / album.tracks.count) > 0.6
          album.update! live: true
        end
      end
      user_albums.create!(album: album)

      sleep sleep_after_album_s
    end

    artist
  end

  def country
    auth_hash['country'] if auth_hash
  end
end
