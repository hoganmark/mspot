class AddTrackPopularity < ActiveRecord::Migration[6.1]
  def change
    add_column :tracks, :popularity, :integer
  end
end
