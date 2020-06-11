require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  before :all do
    password = '12345678'

    @user = User.create(
        name:  'User',
        email: 'user@example.com',
        password: password,
        password_confirmation: password
    )
  end

  describe "GET /new" do
    it "returns http success" do
      get login_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    describe "login with invalid information" do
      before :each do
        post login_path , params: {
            session: {
                email:    '',
                password: ''
            }
        }
      end

      describe 'with incomplete information' do
        it 'cant login' do
          post login_path, params: { session: { email: @user.email, password: '' } }

          expect(subject).to_not redirect_to User.last
        end
      end

      it "display danger flash error" do
        expect(response).to render_template(:new)
        expect(flash[:danger]).to match(/Invalid user\/password combination/)
      end

      describe 'and moves to other page' do
        it "flash do not persists" do
          get root_path

          expect(flash[:danger]).to_not match(/Invalid user\/password combination/)
        end
      end
    end

    describe 'login with valid information' do
      before :each do
        post login_path, params: {
          session: {
            email: @user.email,
            password: @user.password
          }
        }
      end

      it 'redirect to user page' do
        expect(subject).to redirect_to User.last
        follow_redirect!
        expect(response).to render_template(:show)
      end

      it 'show the logged in links' do
        follow_redirect!

        expect(response.body).to_not match /Log in/
        expect(response.body).to match /Log out/
        expect(response.body).to match /Profile/
        expect(is_logged_in?).to be_truthy
      end
    end
  end

  describe "POST /destroy" do

    before :each do
      post login_path, params: {
        session: {
          email: @user.email,
          password: @user.password
        }
      }

      delete logout_path
    end

    describe 'User logs out' do
      it 'session is deleted' do
        expect(is_logged_in?).to be_falsey
      end

      it 'do not show users links' do
        follow_redirect!

        expect(response.body).to match /Log in/
        expect(response.body).to_not match /Log out/
        expect(response.body).to_not match /Profile/
      end

      it 'redirects to root url' do
        follow_redirect!

        expect(response).to render_template('home/index')
      end
    end
  end
end
