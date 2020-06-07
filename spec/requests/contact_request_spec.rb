require 'rails_helper'

RSpec.describe "Contacts", type: :request do
  before :each do
    get contact_url
  end

  describe 'GET /' do
    it 'return http success' do
      expect(response).to have_http_status :success
    end

    it 'should have the correct title' do
        expect(response.body).to match /<title>Contact \| Ruby on Rails Tutorial Sample App<\/title>/
    end
  end
end
