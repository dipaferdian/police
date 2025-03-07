# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GetOfficer', type: :request do

  describe 'Get officers' do
    let(:user) { create(:user, is_admin: true) }
    let!(:rank) { create(:rank) }
    let!(:officers) { 
      5.times do |time|
         create(:officer).ranks << rank
      end
     }

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

    it 'should return officers with rank relation' do
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
      expect(response.parsed_body["data"]["getOfficers"]).to include("officers" => officer_data_type)
      expect(response.parsed_body["data"]["errors"]).to be_nil
    end

    it 'should return officers search by name' do
      officers = create_list(:officer, 10) do |officer|
                    officer.ranks << rank
                end

      variables = { 
        input: {
          page: 1,
          name: officers.first.name
        }
      }

      post '/graphql',
      params: { query: query, variables: variables }.to_json, # Convert params to JSON
      headers: header(user).merge!({ 'Content-Type' => 'application/json' }) # Set JSON headers

      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["data"]["getOfficers"]).to include("officers" => officer_data_type({
        "id"   => officers.first.id,
        "name" => officers.first.name
      }))
      expect(response.parsed_body["data"]["getOfficers"]["officers"].length).to eq(1)
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
      expect(response.parsed_body["errors"]).to include(error_data_type({ "message" => "You are not authorized"}))
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
