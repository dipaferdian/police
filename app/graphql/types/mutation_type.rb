module Types
  class MutationType < Types::BaseObject

    field :create_officer, mutation: Mutations::Admin::Officers::CreateOfficer, description: 'create new officer'
  end
end
