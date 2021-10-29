class AddAlbumNumber < ActiveRecord::Migration[6.1]
  def change
    add_column :albums, :number, :integer
  end
end
