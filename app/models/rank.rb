class Rank < ApplicationRecord
  has_many :rank_officers
  has_many :officers, through: :rank_officers

  validates :name, uniqueness: true, presence: true, length: { maximum: 255 }

  def self.update_ranks(datas:)

    new_ranks = []
    Rank.transaction do
      new_ranks = datas.map do |data|
        name = data[:name]
        rank_id = data[:id]

        rank = Rank.find_by(id: rank_id)

        unless rank
          new_ranks = [
            "errors" => "Rank #{rank_id} not found"
          ]
          raise ActiveRecord::Rollback, "Rank #{rank_id} not found"
        end

        rank.name = name
        if rank.save
          rank
        else
          new_ranks = [
            "errors" => "#{rank.errors.full_messages.join(', ')}"
          ]
          raise ActiveRecord::Rollback, "Failed to update rank: #{rank.errors.full_messages.join(', ')}"
        end
      end
    end

    new_ranks
  end
end
