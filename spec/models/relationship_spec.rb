require 'rails_helper'

RSpec.describe Relationship, type: :model do
  it { should validate_presence_of(:follower_id) }
  it { should validate_presence_of(:followed_id) }

  describe '#follow' do
    before :each do
      @user = create(:user)
      @other_user = create(:user, :lana)
    end

    context 'follow an user' do
      it 'have a follower included' do
        @user.follow(@other_user)
        expect(@user.following?(@other_user)).to be_truthy
        expect(@other_user.followers.include?(@user)).to be_truthy
      end
    end
  end

  describe '#unfollow' do
    before :each do
      @user = create(:user)
      @other_user = create(:user, :lana)
    end

    context 'follow an user' do
      it 'have a follower included' do
        @user.follow(@other_user)
        @user.unfollow(@other_user)
        expect(@user.following?(@other_user)).to_not be_truthy
      end
    end
  end

  describe 'Followers' do
    before :each do
      @user = create(:user)
      @other_user = create(:user, :lana)
      @another_user = create(:user, :archer)

      create_list(:micropost, 10, user: @other_user)
      create_list(:micropost, 10, user: @user)
      create_list(:micropost, 10, user: @another_user)
      @user.follow(@other_user)
    end

    it 'have the right post' do
      @other_user.microposts.each do |post_following|
        expect(@user.feed.include?(post_following)).to be_truthy
      end

      @user.microposts.each do |post_self|
        expect(@user.feed.include?(post_self)).to be_truthy
      end

      @another_user.microposts.each do |post_unfollowed|
        expect(@user.feed.include?(post_unfollowed)).not_to be_truthy
      end
    end
  end
end
