class Album < ApplicationRecord
  has_many :tracks, dependent: :destroy
  belongs_to :artist
end
