module Mutations
  module Admin
    module Ranks
      class UpdateRanks < BaseQueriesMutation
        field :ranks, [Types::RankType], null: false

        argument :ranks, [UpdateRanksInputType], required: true

        def resolve(ranks:)
          authenticate_admin!

          new_ranks = Rank.update_ranks(datas: ranks)

          check_errors(datas: new_ranks)

          {
            ranks: new_ranks
          }
        end
      end
    end
  end
end
