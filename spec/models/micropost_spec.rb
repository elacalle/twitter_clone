require 'rails_helper'

RSpec.describe Micropost, type: :model do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:content) }
  it { should validate_length_of(:content).is_at_most(140) }
  it { should belong_to(:user) }

  describe '#microposts' do
    before do
      @user = create(:user)
      create(:micropost, :orange, user: @user)
      create(:micropost, :tau_manifesto, user: @user)
      create(:micropost, :cat_video, user: @user)
      @most_recent = create(:micropost, :most_recent, user: @user)
    end

    it 'retrieve the most recent' do
      expect(@most_recent).to eq Micropost.first
    end
  end
end
