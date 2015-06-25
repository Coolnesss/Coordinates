require 'rails_helper'

RSpec.describe "Reports", :type => :request do
  describe "GET /reports" do
    it "works! (now write some real specs)" do
      get reports_path
      expect(response).to have_http_status(200)
    end
  end
end
