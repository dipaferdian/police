

module Mutations
  module User
    module Authentications
      class LoginAuthenticationsInputType < Types::BaseInputObject
        graphql_name 'LoginAuthenticationsInputType'

        argument :email, String, required: true
        argument :password, String, required: true
      end
    end
  end
end
