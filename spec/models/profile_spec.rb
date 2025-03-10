require 'rails_helper'

RSpec.describe Profile, type: :model do

  let!(:officer) { create(:officer) }

  describe 'associations' do
    it { should have_one(:officer) }
  end

  describe 'validations' do
    it { should validate_inclusion_of(:status).in_array(%w[good warning danger]) }
  end

  describe 'data' do

    it "should return default status good" do
      expect(officer.reload.profile.status).to eq("good")
    end
  end
end
