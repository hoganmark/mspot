class SpotifyController < ApplicationController
  def connect
  end

  def callback
    auth_hash = request.env['omniauth.auth']
    @spotify_user = RSpotify::User.new auth_hash
    user = User.find_or_create_by email: @spotify_user.email
    user.update! auth_hash: auth_hash.to_h, userid: @spotify_user.id
  end
end
