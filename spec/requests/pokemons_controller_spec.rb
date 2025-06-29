require 'rails_helper'

RSpec.describe 'PokemonsController', type: :request do
  describe '#index' do
    it '200が返ること' do
      get pokemons_path
      expect(response).to have_http_status(:ok)
    end
  end
end
