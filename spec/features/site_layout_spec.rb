require 'rails_helper'

RSpec.feature "SiteLayouts", type: :feature do
  before :each do
    visit root_path
  end

  describe 'home pagelinks' do
    it 'layouts links' do
      expect(page.has_selector?("a[href=\"#{root_path}\"]", count: 2)).to be_truthy
      expect(page.has_selector?("a[href=\"#{about_path}\"]")).to be_truthy
      expect(page.has_selector?("a[href=\"#{contact_path}\"]")).to be_truthy
      expect(page.has_selector?("a[href=\"#{help_path}\"]")).to be_truthy
    end
  end
end
