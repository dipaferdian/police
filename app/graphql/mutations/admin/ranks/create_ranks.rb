module Mutations
  module Admin
    module Ranks
      class CreateRanks < BaseQueriesMutation
        field :ranks, [Types::RankType], null: false

        argument :ranks, [CreateRanksInputType], required: true

        def resolve(ranks:)
          authenticate_admin!

          new_ranks = Rank.save_ranks(datas: ranks)

          check_errors(datas: new_ranks)

          {
            ranks: new_ranks
          }
        end
      end
    end
  end
end
