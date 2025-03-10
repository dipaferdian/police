class Profile < ApplicationRecord
  STATUS_TYPES = %w[good warning danger].freeze
  
  belongs_to  :officer

  validates :status, presence: true, inclusion: { in: STATUS_TYPES }
end
