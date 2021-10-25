Rails.application.routes.draw do
  get '/connect', to: 'spotify#connect'
  get '/auth/spotify/callback', to: 'spotify#callback'
end
