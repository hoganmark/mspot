class CreateFrozenPlaylists < ActiveRecord::Migration[6.1]
  def change
    create_table :frozen_playlists do |t|
      t.references :user
      t.string :playlist_id
      t.string :frozen_playlist_id

      t.timestamps
    end
  end
end
