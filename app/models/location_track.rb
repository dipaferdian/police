class LocationTrack < ApplicationRecord

  belongs_to :officer
  
  before_save :validate_latlong

  private
  def validate_latlong
    if latitude.present?
      errors.add(:latitude, "must be between -90 and 90") unless latitude.between?(-90, 90)
    else
      errors.add(:latitude, "can't be blank")
    end

    if longitude.present?
      errors.add(:longitude, "must be between -180 and 180") unless longitude.between?(-180, 180)
    else
      errors.add(:longitude, "can't be blank")
    end
  end
end
