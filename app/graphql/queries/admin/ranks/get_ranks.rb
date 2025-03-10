module Queries
  module Admin
    module Ranks
      class GetRanks < BaseQueriesMutation
        field :ranks, [Types::RankType], null: false

        argument :page, Integer, required: true
        argument :name, String, required: :false, default_value: nil

        def resolve(page:, name:)
          authenticate_admin!

          ranks = Rank.all

          if name.present?
            ranks = ranks.where(name: name)
          end

          {
            ranks: ranks.paginate(page: page, per_page: 10).order(:name)
          }
        end
      end
    end
  end
end
