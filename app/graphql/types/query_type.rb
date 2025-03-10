module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.
    
    # Officers
    field :get_officers, resolver: Queries::Admin::Officers::GetOfficers, description: 'get officers'

    # Ranks
    field :get_ranks, resolver: Queries::Admin::Ranks::GetRanks, description: 'get ranks'
  end
end
