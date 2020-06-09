require 'rails_helper'

RSpec.describe "SiteLayouts", type: :request do
  before :each do
    get root_url
  end

  describe "GET /site_layouts" do
    it 'have layout links' do
      get root_url

      assert_template 'home/index'
      assert_select "a[href=?]", root_path, count: 2
      assert_select "a[href=?]", help_path, count: 1
      assert_select "a[href=?]", contact_path, count: 2
      assert_select "a[href=?]", about_path, count: 2
      assert_select "a[href=?]", signup_path, count: 2

      get contact_path
      assert_select "title", full_title('Contact')
    end
  end
end
