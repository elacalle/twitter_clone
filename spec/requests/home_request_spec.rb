require 'rails_helper'

RSpec.describe "Homes", type: :request do
  before :each do
    get root_url
  end

  describe "GET /index" do
    it "returns http success" do
      expect(response).to have_http_status :success
    end

    it 'should have the correct title' do
        expect(response.body).to match /Ruby on Rails Tutorial Sample App/
    end
  end
end
