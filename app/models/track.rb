class Track < ApplicationRecord
  belongs_to :album

  serialize :audio_features, JSON

  before_save :set_audio_features

  enum mode: { minor: 0, major: 1 }

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
