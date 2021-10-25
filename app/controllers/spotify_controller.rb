class SpotifyController < ApplicationController
  before_action :check_for_user, except: %i[connect callback]

  def connect
    if user
      redirect_to action: :index
      return
    end
  end

  def logout
    session[:user_id] = nil

    redirect_to action: :connect
  end

  def callback
    @spotify_user = RSpotify::User.new request.env['omniauth.auth']
    user = User.find_or_create_by email: @spotify_user.email
    user.update! auth_hash: @spotify_user.to_hash, userid: @spotify_user.id
    session[:user_id] = user.id

    redirect_to action: :index
  end

  def index
    @spotify_user = user.spotify_user
  end

  def create_playlist
    playlist = user.spotify_user.create_playlist! "random#{Time.current.to_i}"
    playlist.add_tracks! user.spotify_user.playlists.map(&:tracks).map(&:sample).compact

    redirect_to action: :index
  end

  def pause
    user.spotify_user.player&.pause

    redirect_to action: :index
  end

  private

  def user
    return @user if @user

    user_id = session[:user_id]
    @user = User.find_by(id: user_id) if user_id
  end

  def check_for_user
    redirect_to action: :connect if user.nil?
  end
end
