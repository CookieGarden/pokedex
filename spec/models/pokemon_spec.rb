require 'rails_helper'

RSpec.describe Pokemon, type: :model do
  describe 'validation' do
    describe 'name' do
      let(:pokemon) { Pokemon.new(name: 'Pikachu') }
      it 'is valid with a name' do
        expect(pokemon).to be_valid
      end
    end
  end
end
