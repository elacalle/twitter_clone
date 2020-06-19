require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SessionsHelper, type: :helper do
  before :each do
    password = '12345678'

    @user = User.create(
      name:  'User',
      email: 'user@example.com',
      password: password,
      password_confirmation: password
    )

    remember @user
  end

  describe 'current_user' do
    context 'when session is nil' do
      it 'returns the right user' do
        expect(@user).to eq current_user
        expect(is_logged_in?).to be_truthy
      end
    end

    context 'when remember digest is wrong' do
      it 'returns nil' do
        @user.update_attribute(:remember_digest, User.digest(User.new_token))
        expect(current_user).to be_nil
      end
    end
  end
end
