Rails.application.routes.draw do
  get '/connect', to: 'spotify#connect'
  get '/logout', to: 'spotify#logout'
  get '/auth/spotify/callback', to: 'spotify#callback'
  get '/', to: 'spotify#index'
  post 'create_playlist', to: 'spotify#create_playlist'
  post 'create_playlists', to: 'spotify#create_playlists'
  get '/pause', to: 'spotify#pause'
  get '/play', to: 'spotify#play'
  get '/test', to: 'spotify#test'
  get '/my_playlist_copies', to: 'spotify#my_playlist_copies'
  get '/copy/:id', to: 'spotify#copy', as: :copy
  get '/add_missing/:id', to: 'spotify#add_missing', as: :add_missing
  get '/artist/:id', to: 'spotify#show_artist'
  get '/album/:id', to: 'spotify#show_album'
end
