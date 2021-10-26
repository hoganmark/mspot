class Album < ApplicationRecord
  has_many :tracks
  belongs_to :artist
end
