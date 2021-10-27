class AddAvailableMarkets < ActiveRecord::Migration[6.1]
  def change
    add_column :albums, :available_markets, :text
  end
end
