module Queries
  module Admin
    module Officers
      class GetOfficers < Queries::BaseQueries
        field :officers, [Types::OfficerType], null: false

        argument :page, Integer, required: true
        argument :name, String, required: :false, default_value: nil

        def resolve(page:, name:)
          authenticate_admin!

          officers = Officer.left_joins(:ranks)

          if name.present?
            officers = officers.where(name: name)
          end

          {
            officers: officers.paginate(page: page, per_page: 10).order(:id)
          }
        end
      end
    end
  end
end
