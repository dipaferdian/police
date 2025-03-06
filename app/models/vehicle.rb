class Vehicle < ApplicationRecord
  FUEL_TYPES = %w[fosil listrik].freeze

  has_one :officer

  validates :name, presence: true
  validates :fuel, presence: true, inclusion: { in: FUEL_TYPES }

end
