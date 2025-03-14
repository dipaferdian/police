# frozen_string_literal: true

module Mutations
  module User
    module Authentications
      class LoginAuthentications < BaseQueriesMutation
        field :jwt, Types::AuthenticationType, null: false
        
        argument :authentication, LoginAuthenticationsInputType, required: true
        
        def resolve(authentication:)

          user = ::User.find_by(email: authentication[:email])

          return respond_single_error("Invalid credentials") unless user&.authenticate(authentication[:password])

          jwt = { token: JwtService.encode(email: user.email) }

          {
            jwt: jwt
          }
        end
      end
    end
  end
end
