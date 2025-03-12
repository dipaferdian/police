require 'rails_helper'

RSpec.describe LocationTrack, type: :model do

  let!(:officer) { create(:officer) }

  describe 'associations' do
    it { should belong_to(:officer) }
  end

  describe 'officer' do
    it 'should return new officer with new location track' do
      expect(officer.location_track).to be_present
      expect(officer.location_track).to have_attributes({
        "latitude" => nil,
        "longitude" => nil
      })
    end

    it 'should return update valid latlong' do
      officer.location_track.update(latitude: -6.2088, longitude: 106.8456)

      expect(officer.location_track).to have_attributes({
        "latitude" => -6.2088,
        "longitude" => 106.8456
      })
    end

    it 'should return invalid lationg' do
      officer.location_track.update(latitude: nil, longitude: nil)

      expect(officer.location_track.errors.full_messages).to contain_exactly("Latitude can't be blank", "Longitude can't be blank")
    end
  end
end
