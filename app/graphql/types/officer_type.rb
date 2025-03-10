# frozen_string_literal: true

module Types
  class OfficerType < Types::BaseObject
    field :id, Integer, null: false
    field :name, String
    field :ranks, [Types::RankType], null: true
    field :profile, Types::ProfileType, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
