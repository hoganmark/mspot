namespace :artist do
  task add: :environment do
    user = User.last
    names = user.artists.map {|a| a.spotify_artist.related_artists.map(&:name)}.flatten.uniq.sort
    names -= user.artists.pluck :name
    names -= user.ignored_artists.pluck :name

    names.each do |name|
      print "#{name}? "
      a = gets.strip
      if a.downcase == 'y'
        user.add_artist name
      else
        user.ignore_artist name
      end
    end
  end
end
