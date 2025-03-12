

module Mutations
  module Admin
    module Ranks
      class UpdateRanksInputType < Types::BaseInputObject
        graphql_name 'UpdateRanksInputType'

        argument :id, ID, required: true
        argument :name, String, required: true
      end
    end
  end
end
