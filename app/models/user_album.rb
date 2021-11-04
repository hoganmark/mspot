class UserAlbum < ApplicationRecord
  belongs_to :user
  belongs_to :album

  scope :hidden, -> { where(hidden: true) }
  scope :visible, -> { where(hidden: [false, nil]) }

  def hide!
    update! hidden: true
  end
end
