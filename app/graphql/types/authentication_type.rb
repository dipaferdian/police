module Types
  class AuthenticationType < Types::BaseObject
    description 'Authentication'

    field :token, String, null: false, description: "JWT authentication token"
  end
end