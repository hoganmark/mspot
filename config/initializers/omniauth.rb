require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, "f7a0c2e64f54415783aece9fb5bbe7c0", "7de002acff4d4b679738f2b3381776d2", scope: 'user-read-email playlist-modify-public user-library-read user-library-modify user-top-read user-read-recently-played
'
end
