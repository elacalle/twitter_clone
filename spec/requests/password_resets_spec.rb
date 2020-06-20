require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  before :each do
    ActionMailer::Base.deliveries.clear

    @user = User.create(
      name: 'Name',
      email: 'example@example.com',
      password: '12345678',
      password_confirmation: '12345678',
      activated: true
    )
  end

  describe "GET /password_resets" do
    describe "password reset" do
      before :each do
        get new_password_reset_path
      end

      it 'show edit template page' do
        expect(subject).to render_template('password_resets/new')
        assert_select 'input[name=?]', 'password_reset[email]'
      end

      context 'invalid email' do
        before :each do
          post password_resets_path, params: { password_reset: { email: '' } }
        end

        it 'show flash error' do
          expect(flash[:danger]).not_to be_nil
        end

        it 'render password_reset/new template' do
          expect(subject).to render_template('password_resets/new')
        end
      end

      context 'valid email' do
        before :each do
          post password_resets_path, params: { password_reset: { email: @user.email } }
        end

        it 'reset_digest changes' do
          expect(@user.reset_digest).not_to eq @user.reload.reset_digest
        end

        it 'sent an email' do
          expect do
            post password_resets_path, params: { password_reset: { email: @user.email } }
          end.to change { ActionMailer::Base.deliveries.size }.by(1)
        end

        it 'do not show errors' do
          expect(flash[:danger]).to be_nil
        end

        it 'redirects to root url' do
          follow_redirect!
          expect(response).to render_template('home/index')
        end
      end
    end
  end

  describe 'POST /password_resets' do
    before :each do
      post password_resets_path, params: { password_reset: { email: @user.email } }
      @user = assigns(:user)
    end

    context 'invalid email' do
      it 'redirects to root url' do
        get edit_password_reset_path(@user, email: '')

        follow_redirect!
        expect(response).to render_template('home/index')
      end
    end

    context 'inactive user' do
      it 'redirects to root url' do
        @user.update(activated: false)
        get edit_password_reset_path(@user, email: @user.email)

        follow_redirect!
        expect(response).to render_template('home/index')
      end
    end

    context 'right email wrong token' do
      it 'redirects to root url' do
        get edit_password_reset_path('wrong', email: @user.email)
        follow_redirect!
        expect(response).to render_template('home/index')
      end
    end

    context 'right token wrong email' do
      it 'redirects to root url' do
        get edit_password_reset_path(@user.reset_token, email: 'wrong')
        follow_redirect!
        expect(response).to render_template('home/index')
      end
    end

    context 'right email right token' do
      it 'goes to password change page' do
        get edit_password_reset_path(@user.reset_token, email: @user.email)
        expect(response).to render_template('password_resets/edit')
        assert_select "input[name=email][type=hidden][value=?]", @user.email
      end
    end

    context 'invalid password' do
      it 'show error' do
        patch password_reset_path(@user.reset_token),
              params: {
                email: @user.email,
                user: {
                  password: 'foobarfoo',
                  password_confirmation: 'barfoobar',
                },
              }

        expect(response.body).to match /error_explanation/
      end
    end

    context 'empty password' do
      it 'show error' do
        patch password_reset_path(@user.reset_token),
              params: {
                email: @user.email,
                user: {
                  password: '',
                  password_confirmation: '',
                },
              }

        expect(response.body).to match /error_explanation/
      end
    end

    context 'valid password & confirmation' do
      before :each do
        patch password_reset_path(@user.reset_token),
              params: {
                email: @user.email,
                user: {
                  password: '12345678',
                  password_confirmation: '12345678',
                },
              }
      end

      it 'show error' do
        follow_redirect!
        expect(response).to render_template('users/show')
      end

      it 'set nil reset_digest' do
        expect(@user.reload.reset_digest).to be_nil
      end
    end
  end
end
