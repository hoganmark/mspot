class Track < ApplicationRecord
  belongs_to :album

  serialize :audio_features, JSON

  before_save :set_audio_features

  enum mode: { minor: 0, major: 1 }

  scope :in_key_of, ->(key) { where(key: key) }
  scope :time, ->(time) { where(time: time) }

  scope :slow, -> { where('tempo <= 110')}
  scope :medium_pace, -> { where('tempo > 110 and tempo <= 135')}
  scope :fast, -> { where('tempo > 135')}

  scope :short, -> { where('duration < 180') }
  scope :medium_length, -> { where('duration >= 180 and duration < 240') }
  scope :long, -> { where('duration >= 240') }

  scope :acoustic, -> { where(acoustic: true) }
  scope :non_acoustic, -> { where(acoustic: false) }

  scope :old, -> { joins(:album).where("albums.year < 1960") }
  scope :sixties, -> { joins(:album).where("albums.year >= 1960 and albums.year < 1970") }
  scope :seventies, -> { joins(:album).where("albums.year >= 1970 and albums.year < 1980") }
  scope :eighties, -> { joins(:album).where("albums.year >= 1980 and albums.year < 1990") }
  scope :nineties, -> { joins(:album).where("albums.year >= 1990 and albums.year < 2000") }
  scope :aughts, -> { joins(:album).where("albums.year >= 2000 and albums.year < 2010") }
  scope :recent, -> { joins(:album).where("albums.year >= 2010") }

  def set_audio_features
    return unless audio_features.present?

    self.tempo = audio_features['tempo'].round if audio_features['tempo']
    self.acoustic = audio_features['acousticness'] >= 0.5 if audio_features['acousticness']
    self.duration = (audio_features['duration_ms'] / 1000).round if audio_features['duration_ms']
    self.mode = audio_features['mode'] if audio_features['mode']
    self.key = %w[C C# D D# E F F# G G# A A# B][audio_features['key']] if audio_features['key']
    self.time = audio_features['time_signature'] if audio_features['time_signature']
  end

  def spotify_track
    @spotify_track ||= RSpotify::Track.find(uri.split(':').last)
  end

end
