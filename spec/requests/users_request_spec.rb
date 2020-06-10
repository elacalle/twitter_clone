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

  describe "POST /create" do
    describe 'Invalid data' do
      it "User is not created" do
        expect {
            post users_path , params: {
                user: {
                    name: '',
                    email: 'user@invalid',
                    password:              'foo',
                    password_confirmation: 'bar'
                }
            }
        }.to_not change { User.count }

        assert_select "div#error_explanation"
        assert_select "div#error_explanation li", count: 4
        assert_template 'users/new'
      end
    end

    describe 'Valid data' do
      it "User is created" do
        expect {
            post users_path , params: {
                user: {
                    name: 'user',
                    email: 'user@valid.com',
                    password:              '12345678',
                    password_confirmation: '12345678'
                }
            }
        }.to change { User.count }

        follow_redirect!
        expect(response.body).to match /Welcome to Sample App!/
        expect(subject).to render_template("users/show")
      end
    end
  end

end
