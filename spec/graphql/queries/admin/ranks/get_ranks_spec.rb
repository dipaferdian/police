# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GetRanks', type: :request do

  describe 'Get ranks' do

    let(:user) { create(:user, is_admin: true) } 
    let!(:ranks) { create_list(:rank, 10) } 
    let(:ordered_ranks) { Rank.order(:name).select(:id, :name).map { |rank| {
      "id" => rank.id,
      "name" => rank.name      
    } } }

    def rank_data_type(object = {})
      include({
                "id" => be_a(Integer),
                "name" => be_a(String)
              }.merge(object))
    end

    it 'should return ranks' do
      variables = { 
        input: {
          page: 1,
          name: nil
        }
      }

      post '/graphql',
      params: { query: query, variables: variables }.to_json, # Convert params to JSON
      headers: header(user).merge!({ 'Content-Type' => 'application/json' }) # Set JSON headers

      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["errors"]).to be_nil
      expect(response.parsed_body["data"]["getRanks"]["ranks"].length).to eq(10) 
      expect(response.parsed_body["data"]["getRanks"]).to include("ranks" => rank_data_type)
      expect(response.parsed_body["data"]["getRanks"]["ranks"]).to eq(ordered_ranks)
    end

    it 'should search by name' do
      variables = { 
        input: {
          page: 1,
          name: ranks.first.name
        }
      }

      post '/graphql',
      params: { query: query, variables: variables }.to_json, # Convert params to JSON
      headers: header(user).merge!({ 'Content-Type' => 'application/json' }) # Set JSON headers

      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["errors"]).to be_nil
      expect(response.parsed_body["data"]["getRanks"]["ranks"].length).to eq(1) 
      expect(response.parsed_body["data"]["getRanks"]).to include("ranks" => rank_data_type({
        "id"   => ranks.first.id,
        "name" => ranks.first.name
      }))
    end

    it 'should search by name incase-sensitive' do
      rank = create(:rank, name: 'Jendral')

      variables = { 
        input: {
          page: 1,
          name: "jendra"
        }
      }

      post '/graphql',
      params: { query: query, variables: variables }.to_json, # Convert params to JSON
      headers: header(user).merge!({ 'Content-Type' => 'application/json' }) # Set JSON headers

      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["errors"]).to be_nil
      expect(response.parsed_body["data"]["getRanks"]["ranks"].length).to eq(1) 
      expect(response.parsed_body["data"]["getRanks"]).to include("ranks" => rank_data_type({
        "id"   => rank.id,
        "name" => rank.name
      }))
    end

    it 'should return empty search by name' do
      variables = { 
        input: {
          page: 1,
          name: "messi"
        }
      }

      post '/graphql',
      params: { query: query, variables: variables }.to_json, # Convert params to JSON
      headers: header(user).merge!({ 'Content-Type' => 'application/json' }) # Set JSON headers

      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["errors"]).to be_nil
      expect(response.parsed_body["data"]["getRanks"]["ranks"].length).to eq(0) 
    end
  end

  private

  def query
    <<~GRAPHQL
      query GetRanks($input: GetRanksInput!) {
        getRanks(input: $input) {
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
