class User < ApplicationRecord
  serialize :auth_hash, JSON

  def spotify_user
    @spotify_user ||= RSpotify::User.new(auth_hash)
  end
end
