require 'rails_helper'

RSpec.describe 'PokemonsController', type: :request do
  describe '#index' do
    context 'ポケモンが存在する場合' do
      before do
        3.times { Pokemon.create(name: 'ピカチュウ', image_url: 'http://example.com/pikachu.png') }
      end

      it '200が返ること' do
        get pokemons_path
        expect(response).to have_http_status(:ok)
      end

      it 'ポケモンの情報が正しく表示されること' do
        get pokemons_path
        expect(response.body).to include('ピカチュウ')
        expect(response.body).to include('http://example.com/pikachu.png')
      end
    end

    context 'ポケモンが存在しない場合' do
      it '200が返ること' do
        get pokemons_path
        expect(response).to have_http_status(:ok)
      end

      it 'ポケモンの情報が表示されないこと' do
        get pokemons_path
        expect(response.body).not_to include('ピカチュウ')
      end
    end
  end

  describe '#show' do
    context '存在するポケモンを指定した場合' do
      let(:pokemon) { Pokemon.create(name: 'ピカチュウ', image_url: 'http://example.com/pikachu.png') }

      it '200が返ること' do
        get pokemon_path(pokemon.id)
        expect(response).to have_http_status(:ok)
      end

      it 'ポケモンの情報が正しく表示されること' do
        get pokemon_path(pokemon.id)
        expect(response.body).to include('ピカチュウ')
        expect(response.body).to include('http://example.com/pikachu.png')
      end
    end

    context '存在しないポケモンを指定した場合' do
      it '404が返ること' do
        get pokemon_path(id: 9999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
