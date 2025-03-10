# frozen_string_literal: true

module Types
  class ProfileType < Types::BaseObject
    field :id, Integer, null: false
    field :status, String, null: false
  end
end
