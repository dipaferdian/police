module Types
  class MutationType < Types::BaseObject

    field :create_officers, mutation: Mutations::Admin::Officers::CreateOfficers, description: 'create new officers'
    field :login_authentications, mutation: Mutations::User::Authentications::LoginAuthentications, description: 'login authentications'
  end
end
