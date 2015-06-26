require 'rails_helper'

describe "User" do

  it "it can sign in" do
    user = FactoryGirl.create(:user)
    FactoryGirl.create(:report)
    visit signin_path

    fill_in('username', with:'Sam')
    fill_in('password', with:'Samisbest')

    click_button 'Log in'

    expect(page).to have_content("Sign out")
    #check redirect to reports page
    expect(page).to have_content("Useless")
  end

  it "cannot sign in with a nonexistent user" do
    visit signin_path

    fill_in('username', with:'Weird')
    fill_in('password', with:'person')

    click_button 'Log in'

    expect(page).to have_content("Username and/or password mismatch")
  end

  it "cannot sign in with a real user but bad password" do
    FactoryGirl.create(:user)
    visit signin_path

    fill_in('username', with:'Sam')
    fill_in('password', with:'person')

    click_button 'Log in'

    expect(page).to have_content("Username and/or password mismatch")

  end

  it "cannot see reports page without being logged in" do
    visit reports_path

    expect(page).to have_content("You should be signed in to view reports")
  end

end
