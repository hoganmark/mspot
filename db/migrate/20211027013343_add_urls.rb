class AddUrls < ActiveRecord::Migration[6.1]
  def change
    add_column :tracks, :url, :string
  end
end
