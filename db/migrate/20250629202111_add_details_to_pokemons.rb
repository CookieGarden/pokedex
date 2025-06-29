class AddDetailsToPokemons < ActiveRecord::Migration[8.0]
  def change
    add_column :pokemons, :image_url, :string
  end
end
