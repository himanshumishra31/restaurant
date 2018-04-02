require 'rails_helper'

describe Ingredient do
  let(:veg_ingredient) { FactoryBot.create(:ingredient, :veg) }
  let(:non_veg_ingredient) { FactoryBot.create(:ingredient, :non_veg) }

  describe "constant" do
    it "is expected to have valid categories constant" do
      expect( Ingredient::VALID_CATEGORIES ).to eq({ veg: 'veg', non_veg: 'non_veg' })
    end
  end

  describe "included module" do
    it "is expected to have included token generator" do
      expect(Ingredient.ancestors.include?(TokenGenerator)).to eq(true)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_numericality_of(:price).is_greater_than(0).allow_nil }
    it { is_expected.to validate_inclusion_of(:category).in_array(Ingredient::VALID_CATEGORIES.values) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:meal_items).dependent(:destroy) }
    it { is_expected.to have_many(:meals).through(:meal_items) }
    it { is_expected.to have_many(:inventories).dependent(:destroy) }
  end

  describe 'callbacks' do
    it { is_expected.to callback(:set_inventory).after(:create) }
    it { is_expected.to callback(:update_meal_price).after(:update).unless(:price_unchanged?) }
  end

  describe 'scope' do
    describe 'veg' do
      it "is expected to include veg ingredient" do
        expect(Ingredient.veg).to include(veg_ingredient)
      end

      it "is expected not to include non veg ingredient" do
        expect(Ingredient.veg).not_to include(non_veg_ingredient)
      end
    end

    describe 'non_veg' do
      it "is expected to include non veg ingredient" do
        expect(Ingredient.non_veg).to include(non_veg_ingredient)
      end

      it "is expected not to include veg ingredient" do
        expect(Ingredient.non_veg).not_to include(veg_ingredient)
      end
    end
  end

  describe 'private methods' do
    describe '#set_inventory' do
      it 'expects to return true' do
        expect(veg_ingredient.send(:set_inventory)).to eq(true)
      end
    end

    describe '#update_meal_price' do
      it 'expects to return true' do
        expect(veg_ingredient.send(:update_meal_price)).to eq(true)
      end
    end

    describe 'price_unchanged?' do
      it 'is expected return true when price is not changed' do
        expect(veg_ingredient.send(:price_unchanged?)).to eq(true)
      end

      it 'is expected return false when price is changed' do
        veg_ingredient.price = Faker::Number.number
        expect(veg_ingredient.send(:price_unchanged?)).to eq(false)
      end
    end
  end
end
