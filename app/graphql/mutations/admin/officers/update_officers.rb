# frozen_string_literal: true

module Mutations
  module Admin
    module Officers
      class UpdateOfficers < BaseQueriesMutation
        field :officers, [Types::OfficerType], null: false
        
        argument :officers, [UpdateOfficersInputType], required: true
        
        def resolve(officers:)
          authenticate_admin!

          update_officers = Officer.save_officers(datas: officers)

          check_errors(datas: update_officers)
        
          {
            officers: update_officers
          }
        end
      end
    end
  end
end
