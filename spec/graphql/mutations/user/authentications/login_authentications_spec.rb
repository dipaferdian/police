# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'LoginAuthentications', type: :request do

  def error_data_type(object = {})
    include({
      "message" => be_a(String),
      "locations" => be_a(Array),
      "path" => be_a(Array)
    }.merge(object))
  end


  describe 'login authentications' do

    let(:user) { create(:user, is_admin: true) }

    it 'should success authentications' do
      variables = {
        input: {
          users: {
            email: user.email,
            password: "password123"
          }
        }
      }

      post '/graphql', params: { query: query, variables: variables }

      token = ::JwtService.decode(response.parsed_body["data"]["loginAuthentications"]["jwt"]["token"])
      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["errors"]).to be_nil
      expect(response.parsed_body["data"]["loginAuthentications"]).to include({
        "jwt" => be_present
      })
      expect(token).to include({"email" => user.email},{"alg" => "HS256"})
    end

    it 'should failed authentications with wrong password' do
      variables = {
        input: {
          users: {
            email: user.email,
            password: "test"
          }
        }
      }

      post '/graphql', params: { query: query, variables: variables }

      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["errors"]).to include(error_data_type({"message" => "Invalid credentials"}))
      expect(response.parsed_body["data"]["loginAuthentications"]).to be_nil
    end

    it 'should failed authentications with wrong email' do
      variables = {
        input: {
          users: {
            email: "dipaferdian@gmail.com",
            password: "password123"
          }
        }
      }

      post '/graphql', params: { query: query, variables: variables }

      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["errors"]).to include(error_data_type({"message" => "Invalid credentials"}))
      expect(response.parsed_body["data"]["loginAuthentications"]).to be_nil
    end


    it 'should failed authentications with wrong email and password' do
      variables = {
        input: {
          users: {
            email: "wrong@gmail.com",
            password: "wrong"
          }
        }
      }

      post '/graphql', params: { query: query, variables: variables }

      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["errors"]).to include(error_data_type({"message" => "Invalid credentials"}))
      expect(response.parsed_body["data"]["loginAuthentications"]).to be_nil
    end
  end

  private

  def query
    <<~GRAPHQL
    mutation loginAuthentications($input: LoginAuthenticationsInput!){
      loginAuthentications(input: $input){
        jwt{
          token
        },
        errors{
          path
          detail
        }
      }
    }
    GRAPHQL
  end
end