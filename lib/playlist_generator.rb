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
    true
  end

  def generate_with_scopes(scopes, slug: scopes.first)
    playlist = user.playlists.find_or_create_by slug: slug
    tracks = user.tracks.order(popularity: :desc)
    scopes.each {|scope| tracks = tracks.send(scope)}
    playlist.spotify_playlist.replace_tracks! tracks.first(100).sample(20)
  end
end
