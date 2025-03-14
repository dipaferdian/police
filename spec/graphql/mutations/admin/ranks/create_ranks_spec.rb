# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CreateRanks', type: :request do

  describe 'Create ranks' do

    let(:user) { create(:user, is_admin: true) } 
    let!(:ranks) { create_list(:rank, 2) } 

    def rank_data_type(object = {})
      include({
                "id" => be_a(Integer),
                "name" => be_a(String)
              }.merge(object))
    end

    def error_data_type(object = {})
      include({
        "message" => be_a(String),
        "locations" => be_a(Array),
        "path" => be_a(Array)
      }.merge(object))
    end

    it 'should return create new ranks' do
      variables = {
        input: {
          ranks: [
            {
              name: Faker::Name.name
            },
            {
              name: Faker::Name.name
            }
          ]
        }
      }

      post '/graphql', params: { query: query, variables: variables }, headers: header(user)

      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["errors"]).to be_nil
      expect(response.parsed_body["data"]["createRanks"]["ranks"].length).to eq(2)
      expect(response.parsed_body["data"]["createRanks"]).to include("ranks" => all(rank_data_type({
        "name" => be_in(variables[:input][:ranks].map { |item| item[:name] })
      })))
    end

    it 'should return invalid name' do
      variables = {
        input: {
          ranks: [
            {
              name: ""
            },
            {
              name: ""
            }
          ]
        }
      }


      post '/graphql', params: { query: query, variables: variables }, headers: header(user)
  
      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["errors"]).to include(error_data_type({"message" => "Name can't be blank"}))
      expect(response.parsed_body["data"]["createRanks"]).to be_nil
    end

    it 'should return invalid access' do
      variables = {
        input: {
          ranks: [
            {
              name: Faker::Name.name
            },
            {
              name: Faker::Name.name
            }
          ]
        }
      }
  
      post '/graphql', params: { query: query, variables: variables }
  
      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["errors"]).to include(error_data_type({"message" => "You are not authorized"}))
      expect(response.parsed_body["data"]["createRanks"]).to be_nil
    end
  end

  private

  def query
    <<~GRAPHQL
      mutation CreateRanks($input: CreateRanksInput!) {
        createRanks(input: $input) {
          ranks {
            id
            name
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
