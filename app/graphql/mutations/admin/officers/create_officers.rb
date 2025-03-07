# frozen_string_literal: true

module Mutations
  module Admin
    module Officers
      class CreateOfficers < BaseMutation
        field :officers, [Types::OfficerType], null: false
        
        argument :names, [String], required: true
        argument :rank_id, ID, required: false
        
        def resolve(names:, rank_id:)
          authenticate_admin!
  
          rank = Rank.find_by(id: rank_id)
          return respond_single_error("Rank not found") unless rank
          officers = []
          
          Officer.transaction do
            officers = names.map do |name|
              officer = Officer.new(name: name)
              officer.ranks << rank
              if officer.save
                officer
              else
                raise ActiveRecord::Rollback, "Failed to create officer: #{officer.errors.full_messages.join(', ')}"
              end
            end
          end

          return respond_single_error("Failed to create officers") if officers.empty?
        
          {
            officers: officers
          }
        end
      end
    end
  end
end
