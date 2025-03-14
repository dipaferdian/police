
module Mutations
  module Admin
    module Ranks
      class CreateRanksInputType < Types::BaseInputObject
        graphql_name 'CreateRanksInputType'

        argument :name, String, required: true
      end
    end
  end
end
