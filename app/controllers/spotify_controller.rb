class SpotifyController < ApplicationController
  def connect
  end

  def callback
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])

    @email = spotify_user.email
  end
end
