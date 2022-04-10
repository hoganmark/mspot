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

  def test
    @spotify_user = user.spotify_user
  end

  def create_playlist
    playlist = user.spotify_user.create_playlist! "random#{Time.current.to_i}"
    playlist.add_tracks! user.spotify_user.playlists.map(&:tracks).map(&:sample).compact

    redirect_to action: :index
  end

  def create_playlists
    user.create_playlists!

    redirect_to action: :index
  end

  def pause
    user.spotify_user.player&.pause

    redirect_to action: :index
  end

  def show_artist
    @artist = user.artists.find params[:id]
  end

  def show_album
    @album = Album.find params[:id]
  end

  def my_playlist_copies
    if params[:q].present?
      playlist = RSpotify::Playlist.search(params[:q]).detect {|p| p.owner.id == 'spotify'}
      @spotify_playlist = RSpotify::Playlist.find user.userid, playlist.id if playlist
    elsif params[:id].present?
      @spotify_playlist = RSpotify::Playlist.find user.userid, params[:id]
    end

    return unless @spotify_playlist

    copy = user.playlist_copies.find_by(playlist_id: @spotify_playlist.id)
    @spotify_playlist_copy = RSpotify::Playlist.find user.userid, copy.playlist_copy_id if copy
  end

  def copy
    playlist = RSpotify::Playlist.find user.userid, params[:id]
    copy = user.playlist_copies.find_or_create_by(playlist_id: playlist.id)
    if copy.playlist_copy_id.blank?
      spotify_playlist_copy = user.spotify_user.create_playlist! "my #{playlist.name} copy"
      copy.update! playlist_copy_id: spotify_playlist_copy.id, name: spotify_playlist_copy.name
    else
      spotify_playlist_copy = RSpotify::Playlist.find user.userid, copy.playlist_copy_id
    end

    spotify_playlist_copy.replace_tracks! playlist.tracks

    redirect_to my_playlist_copies_path id: playlist.id
  end

  def add_missing
    playlist = RSpotify::Playlist.find user.userid, params[:id]
    copy = RSpotify::Playlist.find user.userid, user.playlist_copies.find_by(playlist_id: playlist.id).playlist_copy_id
    copy_ids = copy.tracks.map(&:id)
    missing = playlist.tracks.reject{|t| t.id.in?(copy_ids)}
    copy.add_tracks! missing, position: 0

    redirect_to my_playlist_copies_path id: playlist.id
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
