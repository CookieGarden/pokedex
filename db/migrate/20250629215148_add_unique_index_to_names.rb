class AddUniqueIndexToNames < ActiveRecord::Migration[8.0]
  def change
    add_index :pokemons, :name, unique: true
    add_index :types, :name, unique: true
  end
end
