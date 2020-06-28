require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  before :each do
    @user = create(:user)
    @other_user = create(:user, :lana)
    @relationship = Relationship.create(follower_id: @user.id, followed_id: @other_user.id)
  end

  describe 'POST /relationships' do
    describe 'logged out' do
      context 'create relationship' do
        it 'dont create it' do
          expect do
            post relationships_path
          end.not_to change(Relationship, :count)
        end

        it 'redirects to login' do
          post relationships_path
          follow_redirect!
          expect(subject).to render_template('sessions/new')
        end
      end
    end

    describe 'logged in' do
      before :each do
        log_in_as @other_user
      end

      it 'create it' do
        expect do
          post relationships_path(followed_id: @user.id)
        end.to change(Relationship, :count)
      end
    end
  end

  describe 'delete /relationships/:id' do
    describe 'logged out' do
      it 'dont delete it' do
        expect do
          delete relationship_path(@relationship)
        end.not_to change(Relationship, :count)
      end

      it 'redirects to login' do
        delete relationship_path(@relationship)
        follow_redirect!
        expect(subject).to render_template('sessions/new')
      end
    end

    describe 'logged in' do
      before :each do
        log_in_as @user
      end

      it 'delete it' do
        expect do
          delete relationship_path(@relationship)
        end.to change(Relationship, :count)
      end
    end
  end
end
