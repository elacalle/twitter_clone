require 'rails_helper'

RSpec.describe "Users", type: :request do

  before :each do
    get signup_path
  end

  describe "GET /index" do
    it "returns http success" do
      expect(response).to have_http_status :success
    end

    it 'should have the correct title' do
      expect(response.body).to match /Sign up \| Ruby on Rails Tutorial Sample App/
    end
  end

end
