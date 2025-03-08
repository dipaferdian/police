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
      include({
                "id" => be_a(Integer),
                "name" => be_a(String),
                "ranks" => rank_data_type({
                  "id" => rank.id,
                  "name" => rank.name
                })
              }.merge(object))
    end

    def error_data_type(object = {})
      include({
        "message" => be_a(String),
        "locations" => be_a(Array),
        "path" => be_a(Array)
      }.merge(object))
    end

    it 'should return new multiple officer' do
      variables = {
        input: {
          officers: [
            {
              name: Faker::Name.name,
              rankId: rank.id
            },
            {
              name: Faker::Name.name,
              rankId: rank.id
            }
          ]
        }
      }

      post '/graphql', params: { query: query, variables: variables }, headers: header(user)

      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["data"]["createOfficers"]).to include("errors" => be_nil)
      expect(response.parsed_body["data"]["createOfficers"]).to include("officers" => all(officer_data_type({
        "name" => be_in(variables[:input][:officers].map { |item| item[:name] })
      })))
      expect(response.parsed_body["data"]["createOfficers"]["officers"].length).to eq(2)
    end

    it 'should return rank not found' do
      variables = {
        input: {
          officers: [
            {
              name: Faker::Name.name,
              rankId: 0
            },
            {
              name: Faker::Name.name,
              rankId: -1
            }
          ]
        }
      }

      post '/graphql', params: { query: query, variables: variables }, headers: header(user)
  
      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["errors"]).to include(error_data_type({"message" => "Rank 0 not found"}))
      expect(response.parsed_body["data"]["createOfficers"]).to be_nil
    end

    it 'should fail to create new officer when name is empty value' do
      variables = {
        input: {
          officers: [
            {
              name: "",
              rankId: rank.id
            },
            {
              name: Faker::Name.name,
              rankId: rank.id
            }
          ]
        }
      }

      post '/graphql', params: { query: query, variables: variables }, headers: header(user)
  
      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["errors"]).to include(error_data_type({"message" => "Name can't be blank"}))
      expect(response.parsed_body["data"]["createOfficers"]).to be_nil
    end

    it 'should fail to create when unauthenticated' do
      variables = {
        input: {
          officers: [
            {
              name: Faker::Name.name,
              rankId: rank.id
            },
            {
              name: Faker::Name.name,
              rankId: rank.id
            }
          ]
        }
      }

      post '/graphql', params: { query: query, variables: variables }
    
      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["errors"]).to include(error_data_type({"message" => "You are not authorized"}))
      expect(response.parsed_body["data"]["createOfficers"]).to be_nil
    end
  end

  private

  def query
    <<~GRAPHQL
    mutation createOfficers($input: CreateOfficersInput!){
      createOfficers(input: $input){
        officers{
          id
          name
          ranks{
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