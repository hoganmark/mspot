class AddLive < ActiveRecord::Migration[6.1]
  def change
    add_column :albums, :live, :boolean
  end
end
