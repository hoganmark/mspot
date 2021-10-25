Rails.application.routes.draw do
  get '/connect', to: 'spotify#connect'
  get '/logout', to: 'spotify#logout'
  get '/auth/spotify/callback', to: 'spotify#callback'
  get '/', to: 'spotify#index'
  post 'create_playlist', to: 'spotify#create_playlist'
end
