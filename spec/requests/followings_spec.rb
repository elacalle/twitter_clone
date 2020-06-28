require 'rails_helper'

RSpec.describe "Followings", type: :request do
  before :each do
    @user = create(:user)
    @other_user = create(:user, :lana)
    Relationship.create(follower_id: @user.id, followed_id: @other_user.id)
    Relationship.create(follower_id: @other_user.id, followed_id: @user.id)
    log_in_as @user
  end

  describe "GET /following" do
    it 'have followers' do
      get following_user_path(@user)
      expect(@user.following.empty?).to be_falsy
      expect(response.body).to match @user.following.count.to_s

      @user.following.each do |user|
        assert_select "a[href=?]", user_path(@user)
      end
    end
  end

  describe "GET /followers" do
    it 'have followers' do
      get followers_user_path(@user)
      expect(@user.followers.empty?).to be_falsy
      expect(response.body).to match @user.following.count.to_s

      @user.following.each do |user|
        assert_select "a[href=?]", user_path(@user)
      end
    end
  end
end
