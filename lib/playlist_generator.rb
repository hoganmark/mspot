class PlaylistGenerator
  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  def generate!
    %w[slow fast short long acoustic live sixties eighties].each {|scope| generate_with_scopes([scope]) }
    generate_with_scopes(%w[fast short studio major], slug: 'short n sweet')
    generate_with_scopes(%w[slow long acoustic], slug: :chill)
    generate_with_scopes([], slug: :random)
    generate_flow
    true
  end

  def generate_with_scopes(scopes, slug: scopes.first)
    playlist = user.playlists.find_or_create_by slug: slug
    tracks = user.tracks.order(popularity: :desc)
    scopes.each {|scope| tracks = tracks.send(scope)}
    playlist.spotify_playlist.replace_tracks! tracks.first(100).sample(20)
  end

  def generate_flow
    playlist = user.playlists.find_or_create_by slug: :flow
    tracks = user.tracks.order(popularity: :desc).first(500).to_a
    playlist_tracks = tracks.sample(1)
    tracks -= playlist_tracks

    (1...100).each do |i|
      tracks.shuffle!
      last_track = playlist_tracks.last
      if i % 2 != 0
        track = tracks.detect{|t| t.send(next_speed(last_track)) && (t.key == last_track.key)}
      else
        track = tracks.detect{|t| t.send(next_speed(last_track))}
      end
      playlist_tracks << track
      tracks -= [track]
    end

    playlist.spotify_playlist.replace_tracks! playlist_tracks
  end

  private

  def next_speed(track)
    if track.slow?
      :steady?
    elsif track.steady?
      :fast?
    else
      :slow?
    end
  end
end
