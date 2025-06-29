require 'rails_helper'

RSpec.describe Type, type: :model do
  describe 'validation' do
    let(:type) { Type.new(name: 'でんき') }
    describe 'name' do
      it '名前があれば有効' do
        expect(type).to be_valid
      end
    end
  end

  describe '.fetch_and_save_type_data' do
    before do
      allow(Faraday).to receive(:get).and_return(double(success?: true, body: '{"name": "でんき"}'))
      allow(Type).to receive(:upsert_all)
    end

    it 'タイプデータを取得して保存する' do
      expect { Type.fetch_and_save_type_data }.not_to raise_error
      expect(Faraday).to have_received(:get).exactly(18).times # 1から18までのタイプ
      expect(Type).to have_received(:upsert_all)
    end

    it 'エラーが発生しても正常に処理を続行する' do
      allow(Faraday).to receive(:get).and_raise(StandardError.new('API error'))
      expect { Type.fetch_and_save_type_data }.not_to raise_error
    end
  end
end
