Rails.application.routes.draw do
  get '/connect', to: 'spotify#connect'
end
