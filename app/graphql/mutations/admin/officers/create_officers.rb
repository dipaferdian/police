# frozen_string_literal: true

module Mutations
  module Admin
    module Officers
      class CreateOfficers < BaseMutation
        field :officer, Types::OfficerType, null: false
        
        argument :name, String, required: true
        argument :rank_id, ID, required: false
        
        def resolve(name:, rank_id:)
          authenticate_admin!
  
          rank = Rank.find_by(id: rank_id)
          return respond_single_error("Rank not found") unless rank
        
          officer = Officer.new(name: name)
          officer.ranks << rank 
          return respond_single_error("Failed to create officer") unless officer.save
        
          {
            officer: officer
          }
        end
      end
    end
  end
end
