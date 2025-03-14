# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UpdateOfficers', type: :request do

  let(:user) { create(:user, is_admin: true) }
  let!(:rank) { create(:rank) }
  let(:officers) { create_list(:officer, 2) do |officer| officer.ranks << rank end }

  describe 'Update officers' do

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
                }),
                "profile" => profile_data_type
              }.merge(object))
    end

    def profile_data_type(object = {})
      include({
                "id" => be_a(Integer),
                "status" => be_a(String)
              }.merge(object))
    end

    def error_data_type(object = {})
      include({
        "message" => be_a(String),
        "locations" => be_a(Array),
        "path" => be_a(Array)
      }.merge(object))
    end

    it 'should return update multiple officer' do
      variables = {
        input: {
          officers: [
            {
              id: officers.first.id,
              name: Faker::Name.name
            },
            {
              id: officers.last.id,
              name: Faker::Name.name
            }
          ]
        }
      }

      post '/graphql', params: { query: query, variables: variables }, headers: header(user)

      expect(response).to have_http_status(200)
      expect(response.request.method).to eq("POST")
      expect(response.parsed_body["errors"]).to be_nil
      expect(response.parsed_body["data"]["updateOfficers"]).to include("officers" => all(officer_data_type({
        "name" => be_in(variables[:input][:officers].map { |item| item[:name] })
      })))
      expect(response.parsed_body["data"]["updateOfficers"]["officers"].length).to eq(2)
    end
  end

  private

  def query
    <<~GRAPHQL
    mutation updateOfficers($input: UpdateOfficersInput!){
      updateOfficers(input: $input){
        officers{
          id
          name
          ranks{
            id
            name
          }
          profile{
            id
            status
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