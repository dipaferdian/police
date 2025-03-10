class Profile < ApplicationRecord
  STATUS_TYPES = %w[good warning danger].freeze
  
  has_one  :officer

  validates :status, presence: true, inclusion: { in: STATUS_TYPES }

  def self.create_profile(officer:)
    new_profile = Profile.new
    new_profile.status = "good"
    new_profile.officer_id = officer.id
    new_profile.save
    new_profile
  end
end
