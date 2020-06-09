require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  before :all do
    @title = 'Ruby on Rails Tutorial Sample App'
  end

  describe 'full title helper is empty' do
    it 'Just show moto' do
      expect(full_title).to eq @title
    end
  end

  describe 'full title helper is not empty' do
    %w[Contact Help About].each do |moto|
      it "Shows the title #{moto} with moto" do
        expect(full_title(moto)).to eq "#{moto} | #{@title}"
      end
    end
  end
end
