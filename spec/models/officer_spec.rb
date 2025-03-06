require 'rails_helper'

RSpec.describe Officer, type: :model do

  let!(:vehicle) { create(:vehicle, fuel: "listrik") }

  let!(:rank) do
    create(:rank, name: "Anggota")
  end

  let!(:rank_officer) do
    create(:rank_officer, rank_id: rank.id, officer_id: officer.id)
  end

  let(:office) { create(:office) }

  let!(:officer) do
    create(:officer, vehicle: vehicle, office: office)
  end

  describe "association" do

    def rank_type_data(object = {})
      have_attributes({
                id: be_a(Integer),
                name: be_a(String),
                created_at: be_a(ActiveSupport::TimeWithZone),
                updated_at: be_a(ActiveSupport::TimeWithZone)
              }.merge(object))
    end

    def get_officer
      Officer.find(officer.id)
    end

    it 'has_one Rank through RankOfficer' do
      t = Officer.reflect_on_association(:rank)
      expect(t.macro).to eq(:has_one)
    end

    it 'has_one RankOfficer' do
      t = Officer.reflect_on_association(:rank_officer)
      expect(t.macro).to eq(:has_one)
    end

    it 'should officer have a rank' do
      expect(get_officer.rank).to rank_type_data
      expect(get_officer.rank).to have_attributes(name: "Anggota")
    end

    it { should belong_to(:vehicle).optional(true) }
    it 'should officer have vehicle' do
      expect(officer.vehicle).to be_present
    end

    it 'should not able to have vehicle already has by other officer' do
      expect(officer.vehicle).to be_present
      expect {
        create(:officer, vehicle: vehicle)
      }.to raise_error(ActiveRecord::RecordInvalid, /Vehicle has already been taken/)
    end

    it 'should officer have office' do
      expect(officer.office).to be_present
    end

    it 'should able to have office already has by other officer' do
      create(:officer, office: office)
      expect(office.reload.officers.count).to eq(2)
    end

  end

  describe 'validate input' do
    it 'should be valid when input string with valid input' do
      expect(officer).to be_valid
    end

    context 'When input string as nil' do
      before do
        officer.name = nil
      end

      it 'should be not valid' do
        expect(officer).not_to be_valid
      end
    end
  end
end
