require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:user) { User.new name: 'John Doe', email: 'email@example.org', password: '123456', password_confirmation: '123456' }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_length_of(:name).is_at_most(50) }
    it { should validate_length_of(:email).is_at_most(255) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_length_of(:password).is_at_least(6) }
    it { should have_many(:microposts).dependent(:destroy) }

    %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com].each do |email|
      it { should_not allow_value(email).for(:email) }
    end

    describe 'authenticated' do
      it "should return false with nil digest" do
        user.remember_digest = nil
        user.save

        expect(user.authenticated?(:remember, '')).to eq false
      end
    end
  end
end
