require 'rails_helper'

RSpec.describe Pokemon, type: :model do
  describe 'validation' do
    let(:pokemon) { Pokemon.new(name: 'テスト', image_url: 'http://example.com/test.png') }
    describe 'name' do
      it '名前があれば有効' do
        expect(pokemon).to be_valid
      end
    end
    describe 'image_url' do
      it '画像URLがあれば有効' do
        expect(pokemon).to be_valid
      end
    end
  end

  describe '.fetch_and_save_pokemon_data' do
    before do
      allow(Faraday).to receive(:get).and_return(double(body: '{}'))
      allow(Pokemon).to receive(:upsert_all)
    end

    it 'ポケモンデータを取得して保存する' do
      expect { Pokemon.fetch_and_save_pokemon_data(1, 10) }.not_to raise_error
      expect(Faraday).to have_received(:get).exactly(20).times # 10 species + 10 pokemon
      expect(Pokemon).to have_received(:upsert_all)
    end

    it 'エラーが発生しても正常に処理を続行する' do
      allow(Faraday).to receive(:get).and_raise(StandardError.new('API error'))
      expect { Pokemon.fetch_and_save_pokemon_data(1, 10) }.not_to raise_error
    end
  end
end
