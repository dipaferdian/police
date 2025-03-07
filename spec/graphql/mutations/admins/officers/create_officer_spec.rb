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
          names: [
            Faker::Name.name,
            Faker::Name.name
          ],
          rankId: rank.id
        }
      }

      post '/graphql', params: { query: query, variables: variables }, headers: header(user)

      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["data"]["createOfficers"]).to include("officers" => all(officer_data_type({
        "name" => be_in(variables[:input][:names])
      })))
      expect(response.parsed_body["data"]["createOfficers"]["officers"].length).to eq(2)
      expect(response.parsed_body["data"]["createOfficers"]).to include("errors" => be_nil)
    end

    it 'should return new officer' do
      variables = {
        input: {
          names: [Faker::Name.name],
          rankId: rank.id
        }
      }

      post '/graphql', params: { query: query, variables: variables }, headers: header(user)

      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["data"]["createOfficers"]).to include("officers" => all(officer_data_type({
        "name" => be_in(variables[:input][:names])
      })))
      expect(response.parsed_body["data"]["createOfficers"]["officers"].length).to eq(1)
      expect(response.parsed_body["data"]["createOfficers"]).to include("errors" => be_nil)
    end

    it 'should reuturn rank not found' do
      variables = {
        input: {
          names: [Faker::Name.name],
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
          names: [""],
          rankId: rank.id
        }
      }

      post '/graphql', params: { query: query, variables: variables }, headers: header(user)
  
      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["data"]["createOfficers"]).to be_nil
      expect(response.parsed_body["errors"]).to include(error_data_type({"message" => "Failed to create officers"}))
    end

    it 'should fail to create when unauthenticated' do
      variables = {
        input: {
          names: [Faker::Name.name],
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