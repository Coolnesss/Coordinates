require 'rails_helper'

RSpec.describe "Reports", :type => :request do
  describe "GET /reports" do

    it "cannot get json of reports without being authorized" do
      FactoryGirl.create :report
      get "/reports", {}, { "Accept" => "application/json" }

      expect(response.status).to eq 302
      expect(response).not_to include("Useless")
    end
  end

  describe "POST /reports" do
    it "cannot add a report without being authorized" do
      json = { :format => 'json',
        :report => {
          :cause => "fixed",
          :description => "bar",
          :email => "lol@chang.fi",
          :position_id => 1
        }
      }
      post "/reports.json", json

      expect(Report.count).to eq(0)
    end
  end
end
