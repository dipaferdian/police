require 'rails_helper'

RSpec.describe Profile, type: :model do

  let!(:officer) { create(:officer) }

  describe 'associations' do
    it { should belong_to(:officer) }
  end

  describe 'validations' do
    it { should validate_inclusion_of(:status).in_array(%w[good warning danger]) }
  end

  describe 'officer' do

    it "should return default status officer is good" do
      expect(officer.reload.profile.status).to eq("good")
    end
  end
end
