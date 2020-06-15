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

      it 'show the user links' do
        follow_redirect!

        expect(response.body).to_not match /Log in/
        expect(response.body).to match /Log out/
        expect(response.body).to match /Profile/
        expect(is_logged_in?).to be_truthy
      end

      describe 'login with valid information followed by logout' do
        it 'show guest links' do
          expect(is_logged_in?).to be_truthy

          delete logout_path

          follow_redirect!

          expect(is_logged_in?).to be_falsey
          expect(response).to render_template('home/index')

          delete logout_path

          follow_redirect!
          expect(response.body).to match /Log in/
          expect(response.body).to_not match /Log out/
          expect(response.body).to_not match /Profile/
        end
      end
    end

    describe 'remembering' do
      context 'enabled' do
        it 'cookie is empty' do
          log_in_as(@user, remember_me: 0)

          expect(cookies[:remember_token]).to be_nil
        end

        it 'cookie is not empty' do
          log_in_as(@user, remember_me: 1)
          jar = ActionDispatch::Cookies::CookieJar.build(request, cookies.to_hash)

          expect(jar.encrypted[:remember_token]).to eq assigns(:user).remember_token
        end
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
