require 'rails_helper'
include ActionDispatch::TestProcess

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
    position = FactoryGirl.build(:position, name: "reallyreallyreallyreallylongname")
    position.save

    expect(position).not_to be_valid
    expect(Position.count).to eq(0)
  end

  it "wont save a position with a really long description" do
    position = FactoryGirl.build(:position,
      description: "reallyreallyreallyreallylongname
      asddasdasdasdasadsadsadsadsssssssssssssssssssssssssssssssssssssssss
      adsssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
      adssssssssssssssssssssssssssssssssssssssssssssssssssss
      adssssssssssssssssssssssssssssssssssssssssssssssssss
      asdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
      adsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss"
    )
    position.save
    expect(position).not_to be_valid
    expect(Position.count).to eq(0)
  end

  it "will save a float longitude" do
    position = FactoryGirl.create(:position, lon: 2769825.02282873)

    expect(position).to be_valid
    expect(Position.count).to eq(1)

  end

  it "can add updates" do
    position = position = FactoryGirl.create(:position)
    position.updates = "This place is awful"
    position.save

    expect(position).to be_valid
    expect(Position.count).to eq(1)
  end

  it "will save a float latitude" do
    position = FactoryGirl.create(:position, lat: 8436068.06177812)

    expect(position).to be_valid
    expect(Position.count).to eq(1)
  end

  it "wont save a position with a string longitude" do
    position = FactoryGirl.build(:position, lon: "boss")
    position.save

    expect(position).not_to be_valid
    expect(Position.count).to eq(0)
  end

  it "will save a position with a picture" do
    AWS.stub!
    position = FactoryGirl.create(:position)

    file = File.new(Rails.root.join('spec/helpers/missing.png'))
    image = position.pictures.create(:image => ActionDispatch::Http::UploadedFile.new(:tempfile => file, :filename => File.basename(file), :content_type => 'image/png'))
    image.image_content_type = "image/png"

    expect(image).to be_valid
    expect(position.pictures.first.image_file_name).to eq("missing.png")
    expect(image.position).to eq(position)
  end

  it "will save a position with two images" do
    AWS.stub!
    position = FactoryGirl.create(:position)

    file = File.new(Rails.root.join('spec/helpers/missing.png'))
    filetwo = File.new(Rails.root.join('spec/helpers/woodpecker.png'))

    image = position.pictures.create(:image => ActionDispatch::Http::UploadedFile.new(:tempfile => file, :filename => File.basename(file), :content_type => 'image/png'))
    imagetwo = position.pictures.create(:image => ActionDispatch::Http::UploadedFile.new(:tempfile => filetwo, :filename => File.basename(filetwo), :content_type => 'image/png'))

    imagetwo.image_content_type = "image/png"
    image.image_content_type = "image/png"

    expect(position.pictures.first.image_file_name).to eq("missing.png")
    expect(position.pictures.second.image_file_name).to eq("woodpecker.png")

    expect(image).to be_valid
    expect(imagetwo).to be_valid
    expect(position).to be_valid
  end

  it "will save a position with no email" do
    position = FactoryGirl.build(:position, email: nil)
    position.save
    expect(position).to be_valid
    expect(Position.count).to eq(1)
  end

  it "wont save a position with an invalid email" do
    position = FactoryGirl.build(:position, email: "lol")
    position.save

    expect(position).not_to be_valid
    expect(Position.count).to eq(0)
  end

end
