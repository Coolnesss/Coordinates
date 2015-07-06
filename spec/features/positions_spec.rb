require 'rails_helper'
require 'rack/test'

describe "Position" do

  before (:each) do
    @position = FactoryGirl.create :position
    FactoryGirl.create :user
  end

  it "can vote on a position" do
    visit vote_position_path(@position)

    expect(Position.first.votes).to eq(1)
  end

  it "can destroy position with auth" do
    sign_in(username:"Sam", password:"Samisbest")
    visit positions_path

    click_link('Destroy')
    expect(Position.count).to eq(0)
  end

  it "can edit position with auth" do
    sign_in(username:"Sam", password:"Samisbest")
    visit positions_path

    click_link('Edit')
    fill_in('Description', with: "This is the best description")

    click_button('Update Position')
    expect(Position.first.updated_at).not_to eq(Position.first.created_at)
    expect(Position.first.description).to eq("This is the best description")
  end
end
