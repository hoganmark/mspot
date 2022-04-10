class RenameToPlaylistCopies < ActiveRecord::Migration[6.1]
  def change
    rename_table :frozen_playlists, :playlist_copies
    rename_column :playlist_copies, :frozen_playlist_id, :playlist_copy_id
  end
end
