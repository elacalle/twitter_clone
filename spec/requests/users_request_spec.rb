require 'rails_helper'

RSpec.describe 'Users', type: :request do
  before :each do
    get signup_path

    password = '12345678'

    @user = User.create(
      name: 'Name',
      email: 'example@example.com',
      password: '12345678',
      password_confirmation: '12345678',
      activated: true
    )

    @admin = User.create(
      name: 'Name',
      email: 'admin@example.com',
      password: '12345678',
      password_confirmation: '12345678',
      activated: true,
      admin: true 
    )

    30.times do |n|
      User.create(
        name: Faker::Name.name,
        email: "email#{n}@example.com",
        password: password,
        activated: true,
        password_confirmation: password
      )
    end
  end

  describe 'GET /index' do
    it 'returns http success' do
      expect(response).to have_http_status :success
    end

    it 'has the correct title' do
      expect(response.body).to match(/Sign up \| Ruby on Rails Tutorial Sample App/)
    end

    context 'when user is not logged in' do
      it 'redirect' do
        get users_path

        follow_redirect!

        expect(subject).to render_template('sessions/new')
      end
    end

    describe 'as user' do
      it 'paginate users' do
        log_in_as @user
        follow_redirect!
        get users_path
        expect(subject).to render_template('users/index')
        assert_select 'div.pagination', count: 2

        User.paginate(page: 1).each do |user|
          assert_select 'a[href=?]', user_path(user), text: user.name
        end
      end
    end

    describe 'admin' do
      it 'show delete links' do
        delete logout_path
        log_in_as @admin
        follow_redirect!

        get users_path
        User.paginate(page: 1).each do |user|
          unless user == @admin
            assert_select 'a[href=?]', user_path(user), text: 'delete'
          end
        end
      end
    end
  end

  describe 'POST /create' do
    describe 'Invalid data' do
      it 'User is not created' do
        expect do
          post users_path, params: {
            user: {
              name: '',
              email: 'user@invalid',
              password: 'foo',
              password_confirmation: 'bar',
            },
          }
        end.not_to change(User, :count)

        assert_select 'div#error_explanation'
        assert_select 'div#error_explanation li', count: 4
        assert_template 'users/new'
      end
    end

    describe 'Valid data' do
      it 'User is created' do
        expect do
          post users_path, params: {
            user: {
              name: 'user',
              email: 'user@valid.com',
              password: '12345678',
              password_confirmation: '12345678',
            },
          }
        end.to change(User, :count)

        follow_redirect!
      end

      it 'send an activation email' do
        expect do
          post users_path, params: {
            user: {
              name: 'user',
              email: 'user@valid.com',
              password: '12345678',
              password_confirmation: '12345678',
            },
          }
        end.to change { ActionMailer::Base.deliveries.size }.by(1)
      end
    end
  end

  describe 'POST /update' do
    before :each do
      @other_user = User.create(
        name: 'Name1',
        email: 'example1@example.com',
        password: '12345678',
        password_confirmation: '12345678',
        activated: true
      )

      log_in_as @user
      get edit_user_path(@user)
    end

    describe 'logged in' do
      describe 'edit' do
        context 'unsucceful' do
          it 'come back to edit page' do
            expect(subject).to render_template('users/edit')

            patch user_path(@user), params: {
              user: {
                name: '',
                email: 'user@valid',
                password: 'foo',
                password_confirmation: 'bar',
              },
            }

            expect(response.body).to match(/The form contains 4 errors./)
            expect(subject).to render_template('users/edit')
          end
        end

        context 'update admin params' do
          it 'admin attr is not modified' do
            expect(subject).to render_template('users/edit')

            patch user_path(@user), params: {
              user: {
                name: 'Ernesto',
                email: 'example@valid.com',
                password: '1345678',
                password_confirmation: '12345678',
              },
            }

            expect(@user.admin).not_to be_truthy
          end
        end

        context 'edit a wrong user' do
          it 'redirects' do
            get edit_user_path(@other_user)

            follow_redirect!

            expect(flash[:danger]).to be_nil
            expect(subject).to render_template('sessions/new')
          end
        end

        context 'update a wrong user' do
          it 'redirects' do
            patch user_path(@other_user), params: {
              user: {
                name: @user.name,
                email: @user.email,
              },
            }

            follow_redirect!

            expect(flash[:danger]).to be_nil
            expect(subject).to render_template('sessions/new')
          end
        end

        context 'succeful' do
          it 'go to profile page' do
            expect(subject).to render_template('users/edit')
            patch user_path(@user), params: {
              user: {
                name: 'New name',
                email: 'valid@example.com',
                password: '',
                password_confirmation: '',
              },
            }

            follow_redirect!

            expect(flash[:danger]).to be_nil
            expect(subject).to render_template('users/show')

            @user.reload

            expect(@user.name).to eq 'New name'
            expect(@user.email).to eq 'valid@example.com'
          end
        end
      end
    end

    describe 'logged out' do
      context 'edit infomation' do
        it 'redirect' do
          delete logout_path
          get edit_user_path(@user)

          expect(flash[:danger]).not_to be_nil

          follow_redirect!
          expect(response).to render_template('sessions/new')
        end

        it 'redirects friendly' do
          delete logout_path
          get edit_user_path(@other_user)

          log_in_as @other_user
          follow_redirect!

          expect(flash[:danger]).to be_nil
          expect(subject).to render_template('users/edit')
        end
      end

      context 'update infomation' do
        it 'redirect' do
          delete logout_path
          patch user_path(@user), params: {
            user: {
              name: 'New name',
              email: 'valid@example.com',
              password: '',
              password_confirmation: '',
            },
          }

          expect(flash[:danger]).not_to be_nil

          follow_redirect!

          expect(response).to render_template('sessions/new')
        end
      end
    end
  end

  describe 'POST /delete' do
    describe 'user logged out' do
      context 'delete a user' do
        it 'redirects to login page' do
          expect do
            delete user_path(@user)
          end.not_to change(User, :count)

          follow_redirect!
          expect(response).to render_template('sessions/new')
        end
      end
    end

    describe 'user logged in' do
      context 'delete a user' do
        it 'redirects to login page' do
          log_in_as @user
          random_user = User.all.sample

          expect do
            delete user_path(random_user)
          end.not_to change(User, :count)

          follow_redirect!
          expect(response).to render_template('home/index')
        end
      end
    end
  end

  describe 'When user is not logged in' do
    context 'follow a user' do
      it 'gets redirected' do
        get following_user_path(@user)

        follow_redirect!
        expect(response).to render_template('sessions/new')
      end
    end

    context 'unfollow a user' do
      it 'gets redirected' do
        get followers_user_path(@user)

        follow_redirect!
        expect(response).to render_template('sessions/new')
      end
    end
  end
end
