class AddVisibleToUserAlbum < ActiveRecord::Migration[6.1]
  def change
    add_column :user_albums, :hidden, :boolean
  end
end
