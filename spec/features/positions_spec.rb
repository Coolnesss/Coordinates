require 'rails_helper'

describe "Position" do

  it "can vote on a position" do
    pos = FactoryGirl.create :position

    visit vote_position_path(pos)

    expect(Position.first.votes).to eq(1)
  end
end
