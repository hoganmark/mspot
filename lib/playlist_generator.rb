class PlaylistGenerator
  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  def generate!
    %w[slow steady fast short long acoustic live sixties eighties].each {|scope| generate_with_scope(scope) }
    true
  end

  def generate_with_scope(scope)
    playlist = playlist(scope.to_s)
    playlist.replace_tracks! user.tracks.send(scope).order(popularity: :desc).first(100).sample(20)
  end

  private

  def playlist(name)
    name = 'mspot_' + name
    playlists.detect{|pl| pl.name == name} || spotify_user.create_playlist!(name)
  end

  def playlists
    @playlists ||= spotify_user.playlists
  end

  def spotify_user
    @spotify_user ||= user.spotify_user
  end
end
