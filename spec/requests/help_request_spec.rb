require 'rails_helper'

RSpec.describe "Helps", type: :request do
  before :each do
    get help_url
  end

  describe "GET /index" do
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it 'should have the correct title' do
        expect(response.body).to match /<title>Help \| Ruby on Rails Tutorial Sample App<\/title>/
    end
  end
end
