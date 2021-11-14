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
    playlist = user.playlists.find_or_create_by slug: scope
    playlist.spotify_playlist.replace_tracks! user.tracks.send(scope).order(popularity: :desc).first(100).sample(20)
  end
end
