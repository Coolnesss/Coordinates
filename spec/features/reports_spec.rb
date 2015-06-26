require 'rails_helper'

describe "Report" do

  before :each do
    user = FactoryGirl.create(:user)
    sign_in(username:"Sam", password:"Samisbest")
  end

  it "can ignore created report" do
    FactoryGirl.create(:report)
    visit reports_path

    expect{
      click_link 'Ignore'
    }.to change{Report.first.ignored}.from(false).to(true)

    visit reports_path

    expect(page).not_to have_content("Ignore")
  end

  it "can view position of report" do
    FactoryGirl.create(:report, position: FactoryGirl.create(:position))
    visit reports_path

    click_link 'BestName'

    expect(page).to have_content("The best place on earth")
  end
end
