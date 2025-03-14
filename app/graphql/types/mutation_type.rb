module Types
  class MutationType < Types::BaseObject

    # Officer
    field :create_officers, mutation: Mutations::Admin::Officers::CreateOfficers, description: 'create new officers'
    field :update_officers, mutation: Mutations::Admin::Officers::UpdateOfficers, description: 'update officers'

    # Authectication
    field :login_authentications, mutation: Mutations::User::Authentications::LoginAuthentications, description: 'login authentications'

    # Rank
    field :create_ranks, mutation: Mutations::Admin::Ranks::CreateRanks, description: 'create ranks'
    field :update_ranks, mutation: Mutations::Admin::Ranks::UpdateRanks, description: 'update ranks'
  end
end
