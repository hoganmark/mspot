class SpotifyController < ApplicationController
  def connect
    if user
      redirect_to action: :index
      return
    end
  end

  def logout
    session[:user_id] = nil
  end

  def callback
    auth_hash = request.env['omniauth.auth']
    @spotify_user = RSpotify::User.new auth_hash
    user = User.find_or_create_by email: @spotify_user.email
    user.update! auth_hash: auth_hash.to_h, userid: @spotify_user.id
    session[:user_id] = user.id

    redirect_to action: :index
  end

  def index
    if user.nil?
      redirect_to action: :connect
      return
    end

    @spotify_user = user.spotify_user
  end

  def user
    return @user if @user

    user_id = session[:user_id]
    @user = User.find_by(id: user_id) if user_id
  end
end
