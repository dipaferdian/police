module Types
  class MutationType < Types::BaseObject

    field :create_officers, mutation: Mutations::Admin::Officers::CreateOfficers, description: 'create new officers'
  end
end
