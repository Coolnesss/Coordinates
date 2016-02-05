require 'rails_helper'
require 'rack/test'

describe "Position" do
  before (:each) do
    @position = FactoryGirl.create :position
  end

  describe "When logged in" do

    before (:each) do
      FactoryGirl.create :user
      sign_in(username:"Sam", password:"Samisbest")
    end

    it "can destroy position" do
      visit positions_path

      click_link('Destroy')
      expect(Position.count).to eq(0)
    end

    it "can edit position" do
      visit positions_path

      click_link('Edit')
      fill_in('Description', with: "This is the best description")

      click_button('Update Position')
      expect(Position.first.updated_at).not_to eq(Position.first.created_at)
      expect(Position.first.description).to eq("This is the best description")
    end

    it "calls IssueReporter when the send to API button is pressed for good position" do
      visit positions_path
      allow(IssueReporter).to receive(:send).and_return("great")
      click_link('Send to API')

      wait_for(IssueReporter).to have_received(:send)
    end

    it "shows error for position not in Helsinki when the Send button is pressed" do
      espoo_lon = 24.69422815914966
      espoo_lat = 60.171243441670384

      @position.lat = espoo_lat
      @position.lon = espoo_lon
      @position.save

      visit positions_path
      click_link('Send to API')

      expect(page).to have_content "Failed to send to API. Maybe position isn't in Helsinki?"
    end

    it "doesnt show send button when position already has issue ID" do
      @position.issue_id = "123"
      @position.save

      visit positions_path
      expect(page).not_to have_link("Send to API")
    end

    after (:each) do
      allow(IssueReporter).to receive(:find).and_call_original
      allow(IssueReporter).to receive(:send).and_call_original
    end
  end

  describe "Without being logged in" do
    it "can vote on a position" do
      visit vote_position_path(@position)

      expect(Position.first.votes).to eq(1)
    end

    it "has the correct CSS label when saved with a category" do
      FactoryGirl.create(:position)

      visit positions_path
      expect(page).to have_css('span.label')
      expect(page).to have_css('span.label-default')
    end
  end
end
