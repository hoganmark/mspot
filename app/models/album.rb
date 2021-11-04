require 'csv'

class Album < ApplicationRecord
  has_many :tracks, dependent: :destroy
  belongs_to :artist
  has_many :user_albums, dependent: :destroy
  has_many :users, through: :user_albums

  serialize :available_markets, JSON

  scope :debut, -> { order(:year).first }
  scope :sophomore, -> { order(:year).second }
  scope :latest, -> { order(:year).last }

  scope :live, -> { where(live: true) }
  scope :studio, -> { where(live: [false, nil]) }

  def spotify_album
    @spotify_album ||= RSpotify::Album.find(uri.split(':').last)
  end

  def fix_tracks!
    spotify_album.tracks(limit: 50).select{|track| track.artists.map(&:name).include?(artist.name)}.each do |spotify_track|
      next if tracks.exists?(uri: spotify_track.uri)

      audio_features = spotify_track.audio_features rescue nil
      tracks.create! \
        uri: spotify_track.uri,
        name: spotify_track.name,
        number: spotify_track.track_number,
        popularity: spotify_track.popularity,
        audio_features: audio_features,
        url: spotify_track.external_urls&.values&.first
    end
    true
  end

  def self.corrected_years
    @corrected_years ||= CSV.open(Rails.root + 'config/corrected_release_years.csv').to_h
  end

  def self.ignored_upcs
    @ignored_upcs ||= CSV.open(Rails.root + 'config/ignored_upcs.csv').to_a.flatten
  end

  def special_edition?
    !!special_suffix
  end

  def special_suffix
    ['deluxe', 'deluxe edition', 'bonus tracks', 'abridged', 'extended'].each do |suffix|
      found = ["[#{suffix}]", "(#{suffix})", "- #{suffix}"].detect do |sub_suffix|
        name.downcase.ends_with? sub_suffix
      end
      return found if found
    end

    return nil
  end

  def original_name
    return nil unless special_edition?

    name[0...name.length-special_suffix.length].strip
  end
end
