class Liveness < ActiveRecord::Migration[6.1]
  def change
    add_column :tracks, :live, :boolean
  end
end
