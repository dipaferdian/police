
module Mutations
  module Admin
    module Officers
      class UpdateOfficersInputType < Types::BaseInputObject
        graphql_name 'UpdateOfficersInputType'

        argument :id, ID, required: true
        argument :name, String, required: true
      end
    end
  end
end

