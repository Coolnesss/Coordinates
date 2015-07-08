require 'rails_helper'

RSpec.describe ReportsController, :type => :controller do

  before (:each) do
    FactoryGirl.create :user
    controller.session[:user_id] = 1
  end

  describe "GET reports" do
    it "Can't get reports without being logged in" do
      controller.session[:user_id] = nil
      FactoryGirl.create(:report)

      get :index

      expect(response.status).to eq 302
      expect(response.body).not_to eq "Useless"
    end
  end

  describe "POST reports" do
    it "Can save a report without being logged in" do
      controller.session[:user_id] = nil
      FactoryGirl.create :position
      post :create, report: {position_id: 1, description: 123, cause: "fixed"}
      expect(response.status).to eq 302
      expect(Report.count).to eq(1)
    end
  end

  describe "DELETE reports" do
    it "Can destroy a report" do
      report = FactoryGirl.create(:report)
      delete :destroy, id: 1

      expect(Report.count).to eq(0)
    end

    it "Can't destroy report without login" do
      controller.session[:user_id] = nil
      report = FactoryGirl.create(:report)
      delete :destroy, id: 1

      expect(Report.count).to eq(1)
    end
  end

  describe "PUT reports" do
    it "Can edit a report" do
      report = FactoryGirl.create(:report, description: "Not updated yet! Maybe")
      put :update, id: report, report: {description: "Lol"}

      expect(Report.first.description).to eq("Lol")
    end

    it "Can't edit report without login" do
      controller.session[:user_id] = nil

      report = FactoryGirl.create(:report, description: "Not updated yet! Maybe")
      put :update, id: report, report: {description: "Lol"}

      expect(Report.first.description).to eq("Not updated yet! Maybe")
    end

  end
end
