module Queries
  module Admin
    module Officers
      class GetOfficers < BaseQueriesMutation
        field :officers, [Types::OfficerType], null: false

        argument :page, Integer, required: true
        argument :name, String, required: :false, default_value: nil

        def resolve(page:, name:)
          authenticate_admin!

          officers = Officer.joins(:ranks)

          if name.present?
            officers = officers.where('officers.name ILIKE ?', "%#{name}%")
          end

          {
            officers: officers.paginate(page: page, per_page: 10).order(:id)
          }
        end
      end
    end
  end
end
