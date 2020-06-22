require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  before :each do
    @micropost = create(:micropost, user: create(:user))
    @user = create(:user, :archer)
  end

  describe 'POST /microposts' do
    context 'when user is not logged in' do
      it 'do not create a new post' do
        expect do
          post microposts_path, params: {
            micropost: {
              content: 'Lorem ipsum',
            },
          }
        end.not_to change(User, :count)
      end

      it 'redirect to login url' do
        post microposts_path, params: {
          micropost: {
            content: 'Lorem ipsum',
          },
        }

        follow_redirect!
        expect(subject).to render_template('sessions/new')
      end
    end

    describe 'when the user is logged in' do
      before :each do
        log_in_as(@user)
      end

      context 'post is wrong' do
        it 'do not create a new post' do
          expect do
            post microposts_path, params: {
              micropost: {
                content: '',
              },
            }
          end.not_to change(User, :count)
        end
      end

      context 'post is valid' do
        it 'create a new post' do
          expect do
            post microposts_path, params: {
              micropost: {
                content: 'asda',
              },
            }
          end.to change(Micropost, :count)
        end
      end
    end
  end

  describe 'DELETE /microposts' do
    context 'when user is not logged in' do
      it 'do not delete a post' do
        expect do
          delete micropost_path(@micropost)
        end.not_to change(User, :count)
      end

      it 'redirect to login url' do
        delete micropost_path(@micropost)

        follow_redirect!
        expect(response).to render_template('sessions/new')
      end
    end

    describe 'when user is logged in' do
      context 'delete the wrong post' do
        before :each do
          @michael = create(:user, :michael)
          @micropost = create(:micropost, user: create(:user, :lana))
        end

        it 'do not delete a post' do
          expect do
            delete micropost_path(@micropost)
          end.not_to change(User, :count)
        end

        it 'redirect to login url' do
          delete micropost_path(@micropost)

          follow_redirect!
          expect(response).to render_template('sessions/new')
        end
      end

      context 'delete a correct post' do
        before :each do
          delete logout_path
          log_in_as(@user)
          @micropost = create(:micropost, user: @user)
        end

        it 'delete a post' do
          expect do
            delete micropost_path(@micropost)
          end.to change(Micropost, :count)
        end
      end
    end
  end
end
