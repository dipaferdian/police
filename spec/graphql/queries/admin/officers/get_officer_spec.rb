# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GetOfficer', type: :request do

  describe 'Get officers' do
    let(:user) { create(:user, is_admin: true) }
    let!(:rank) { create(:rank) }
    let!(:officers) { create_list(:officer, 5, rank: rank) }

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
                "rank" => rank_data_type
              }.merge(object))
    end

    it 'should return officers with rank relation' do
      variables = { 
        input: {
          page: 1
        }
      }

      post '/graphql',
      params: { query: query, variables: variables }.to_json, # Convert params to JSON
      headers: header(user).merge!({ 'Content-Type' => 'application/json' }) # Set JSON headers

      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["data"]["getOfficers"]).to include("officers" => officer_data_type)
      expect(response.parsed_body["data"]["errors"]).to be_nil
    end

    it 'should return unauthorized when user is not admin' do
      variables = { 
        input: {
          page: 1
        }
      }

      user.update(is_admin: false)

      post '/graphql',
      params: { query: query, variables: variables }.to_json, # Convert params to JSON
      headers: header(user.reload).merge!({ 'Content-Type' => 'application/json' }) # Set JSON headers

      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["data"]["getOfficers"]).to be_nil
      expect(response.parsed_body["errors"]).to all(include(
        "message" => "You are not authorized"
      ))  
    end
  end

  private

  def query
    <<~GRAPHQL
      query GetOfficers($input: GetOfficersInput!) {
        getOfficers(input: $input) {
          officers {
            id
            name
            rank {
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
