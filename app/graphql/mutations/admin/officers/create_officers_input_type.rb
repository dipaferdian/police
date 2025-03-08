

module Mutations
  module Admin
    module Officers
      class CreateOfficersInputType < Types::BaseInputObject
        graphql_name 'CreateOfficersInputType'

        argument :name, String, required: true
        argument :rank_id, ID, required: true
      end
    end
  end
end
