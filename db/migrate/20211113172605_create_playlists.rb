class CreatePlaylists < ActiveRecord::Migration[6.1]
  def change
    create_table :playlists do |t|
      t.references :user
      t.string :slug
      t.string :uri

      t.timestamps
    end
  end
end
