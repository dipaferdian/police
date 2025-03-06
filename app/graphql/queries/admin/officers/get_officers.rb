module Queries
  module Admin
    module Officers
      class GetOfficers < Queries::BaseQueries
        field :officers, [Types::OfficerType], null: false

        argument :page, Integer, required: true

        def resolve(page:)
          authenticate_admin!

          officers = Officer.left_joins(:rank).order(:id).paginate(page: page, per_page: 10)

          {
            officers: officers
          }
        end
      end
    end
  end
end
