# frozen_string_literal: true

module Mutations
  module User
    module Authentications
      class LoginAuthentications < BaseQueriesMutation
        field :jwt, Types::AuthenticationType, null: false
        
        argument :users, LoginAuthenticationsInputType, required: true
        
        def resolve(users:)

          user = ::User.find_by(email: users[:email])

          return respond_single_error("Invalid credentials") unless user&.authenticate(users[:password])

          jwt = { token: JwtService.encode(email: user.email) }

          {
            jwt: jwt
          }
        end
      end
    end
  end
end
