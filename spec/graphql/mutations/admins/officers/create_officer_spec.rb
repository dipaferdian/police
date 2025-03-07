# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CreateOfficer', type: :request do

  let(:user) { create(:user, is_admin: true) }
  let!(:rank) { create(:rank) }

  describe 'Create officers' do

    
    def rank_data_type(object = {})
      include({
                "id" => be_a(Integer),
                "name" => be_a(String)
              }.merge(object))
    end

    def officer_data_type(object = {})
      ({
                "id" => be_a(Integer),
                "name" => be_a(String),
                "rank" => include("id" => be_a(Integer))
              }.merge(object))
    end

    def error_data_type(object = {})
      include({
        "message" => be_a(String),
        "locations" => be_a(Array),
        "path" => be_a(Array)
      }.merge(object))
    end

    it 'should return new officer' do
      variables = {
        input: {
          name: Faker::Name.name,
          rankId: rank.id
        }
      }

      post '/graphql', params: { query: query, variables: variables }, headers: header(user)

      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["data"]["createOfficers"]).to include("officer" => officer_data_type({
        "name" => variables[:input][:name],
        "rank" => include({
          "id" => rank.id,
          "name" => rank.name
        })
      }))
      expect(RankOfficer.where(officer: response.parsed_body["data"]["createOfficers"]["officer"]["id"], rank: rank).count).to eq(1)
      expect(response.parsed_body["data"]["createOfficers"]).to include("errors" => be_nil)
    end

    it 'should reuturn rank not found' do
      variables = {
        input: {
          name: Faker::Name.name,
          rankId: ""
        }
      }

      post '/graphql', params: { query: query, variables: variables }, headers: header(user)
  
      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["data"]["createOfficers"]).to be_nil
      expect(response.parsed_body["errors"]).to include(error_data_type({"message" => "Rank not found"}))
    end

    it 'should fail to create new officer when name is empty value' do
      variables = {
        input: {
          name: "",
          rankId: rank.id
        }
      }

      post '/graphql', params: { query: query, variables: variables }, headers: header(user)
  
      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["data"]["createOfficers"]).to be_nil
      expect(response.parsed_body["errors"]).to include(error_data_type({"message" => "Failed to create officer"}))
    end

    it 'should fail to create when unauthenticated' do
      variables = {
        input: {
          name: Faker::Name.name,
          rankId: rank.id
        }
      }

      post '/graphql', params: { query: query, variables: variables }
    
      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["data"]["createOfficers"]).to be_nil
      expect(response.parsed_body["errors"]).to include(error_data_type({"message" => "You are not authorized"}))
    end
  end

  private

  def query
    <<~GRAPHQL
    mutation createOfficers($input: CreateOfficersInput!){
      createOfficers(input: $input){
        officer{
          id
          name
          rank{
            id
            name
          }
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