require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe 'associations' do
    it { should have_one(:officer) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:fuel) }
    it { should validate_inclusion_of(:fuel).in_array(%w[fosil listrik]) }
  end

  describe 'constants' do
    it 'defines correct FUEL_TYPES' do
      expect(Vehicle::FUEL_TYPES).to eq(%w[fosil listrik])
      expect(Vehicle::FUEL_TYPES).to be_frozen
    end
  end
end