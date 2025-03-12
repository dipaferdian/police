FactoryBot.define do
  factory :location_track do
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
