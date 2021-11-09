class CreateIgnoreArtists < ActiveRecord::Migration[6.1]
  def change
    create_table :ignored_artists do |t|
      t.string :name
      t.references :user
      t.timestamps

      t.index :name, unique: true
    end
  end
end
