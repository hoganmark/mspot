class AddUpc < ActiveRecord::Migration[6.1]
  def change
    add_column :albums, :upc, :string
  end
end
