class Officer < ApplicationRecord

  has_many :rank_officers
  has_many :ranks, through: :rank_officers

  belongs_to :office, optional: true
  belongs_to :vehicle, optional: true

  validates :name, uniqueness: true, presence: true, length: { maximum: 255 }
  validates :vehicle, uniqueness: true, allow_nil: true
  validates_associated :ranks
end
