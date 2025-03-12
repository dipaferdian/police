class Officer < ApplicationRecord

  has_many :rank_officers
  has_many :ranks, through: :rank_officers
  belongs_to :office, optional: true
  belongs_to :vehicle, optional: true
  has_one    :profile
  has_one    :location_track

  validates :name, uniqueness: true, presence: true, length: { maximum: 255 }
  validates :vehicle, uniqueness: true, allow_nil: true
  validates_associated :ranks

  after_save :set_profile, :set_location_track

  def self.save_officers(datas:)

    new_officers = []
    Officer.transaction do
      new_officers = datas.map do |data|
        name = data[:name]
        rank_id = data[:rank_id]

        rank = Rank.find_by(id: rank_id)
        officer = Officer.new(name: name)

        unless rank
          new_officers = [
            "errors" => "Rank #{rank_id} not found"
          ]
          raise ActiveRecord::Rollback, "Rank #{rank_id} not found"
        end

        officer.ranks << rank
        if officer.save
          officer
        else
          new_officers = [
            "errors" => "#{officer.errors.full_messages.join(', ')}"
          ]
          raise ActiveRecord::Rollback, "Failed to create officer: #{officer.errors.full_messages.join(', ')}"
        end
      end
    end

    new_officers
  end


  private

  def set_profile
    unless self.profile.present?
      create_profile(status: "good")
    end
  end
  
  def set_location_track
    unless self.location_track.present?
      create_location_track()
    end
  end
end
