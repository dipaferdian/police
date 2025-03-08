# frozen_string_literal: true

module Mutations
  module Admin
    module Officers
      class CreateOfficers < BaseQueriesMutation
        field :officers, [Types::OfficerType], null: false
        
        argument :officers, [CreateOfficersInputType], required: true
        
        def resolve(officers:)
          authenticate_admin!

          new_officers = Officer.save_officers(datas: officers)

          check_errors(datas: new_officers)
        
          {
            officers: new_officers
          }
        end
      end
    end
  end
end
