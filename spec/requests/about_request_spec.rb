require 'rails_helper'

RSpec.describe "Abouts", type: :request do
  before :each do
    get about_url
  end

  describe 'GET /index' do
    it 'return http succes' do
      expect(response).to have_http_status(:success)
    end

    it 'should have the correct title' do
        expect(response.body).to match /<title>About \| Ruby on Rails Tutorial Sample App<\/title>/
    end
  end
end
