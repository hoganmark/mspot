class AddNameToFrozenPlaylists < ActiveRecord::Migration[6.1]
  def change
    add_column :frozen_playlists, :name, :string
  end
end
