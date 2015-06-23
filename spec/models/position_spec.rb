require 'rails_helper'

describe Position do
  it "can save a position with name and description" do
    position = FactoryGirl.create(:position)

    expect(position).to be_valid
    expect(Position.count).to eq(1)
  end

  it "wont save a position with only a name" do
    position = Position.create(name: "yes")

    expect(position).not_to be_valid
    expect(Position.count).to eq(0)
  end

  it "wont save a position with a really long name" do
    position = Position.create(
      name: "reallyreallyreallyreallylongname",
      description: "a",
      lon: 123,
      lat: 123
    )

    expect(position).not_to be_valid
    expect(Position.count).to eq(0)
  end

  it "wont save a position with a really long description" do
    position = Position.create(
      name: "l",
      description: "reallyreallyreallyreallylongname
      asddasdasdasdasadsadsadsadsssssssssssssssssssssssssssssssssssssssss
      adsssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
      adssssssssssssssssssssssssssssssssssssssssssssssssssss
      adssssssssssssssssssssssssssssssssssssssssssssssssss
      asdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
      adsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss",
      lon: 123,
      lat: 123
    )

    expect(position).not_to be_valid
    expect(Position.count).to eq(0)
  end

  it "will save a float longitude" do
    position = FactoryGirl.create(:position, lon: 2769825.02282873)

    expect(position).to be_valid
    expect(Position.count).to eq(1)

  end

  it "will save a float latitude" do
    position = FactoryGirl.create(:position, lat: 8436068.06177812)

    expect(position).to be_valid
    expect(Position.count).to eq(1)
  end

  it "wont save a position with a string longitude" do
    position = Position.create(
    name: "america",
    description: "aqwe",
    lon: "boss",
    lat: 123
    )

    expect(position).not_to be_valid
    expect(Position.count).to eq(0)
  end
end
