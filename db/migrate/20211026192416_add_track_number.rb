class AddTrackNumber < ActiveRecord::Migration[6.1]
  def change
    add_column :tracks, :number, :integer
  end
end
