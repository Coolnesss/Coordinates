require 'rails_helper'
require 'webmock/rspec'
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

  it "returns the hash of service codes correctly" do
    codes = Position.service_codes
    expect(codes[171]).to include(:huonovayla)
    expect(codes[198]).to include(:opastekp)
    expect(codes[180]).not_to include(:kunnossapito)
  end

  it "deduces service codes correctly" do
    position = FactoryGirl.create :position
    code = position.deduce_service_code
    expect(code).to eq 171
  end

  it "finds the status from the API" do
    stub_request(:get, /.*8fmht6g1470b3qk8pthg.json.*/).
         to_return(:status => 200, :body => IO.read("spec/fixtures/request.json"), :headers => {})


    position = FactoryGirl.create :position
    position.issue_id = "8fmht6g1470b3qk8pthg"
    position.save
    expect(Position.first.find_status).not_to be_nil
    expect(Position.first.find_status).to eq("open")

  end

  it "finds the detailed status from the API" do
    stub_request(:get, /.*8fmht6g1470b3qk8pthg.json.*/).
         to_return(:status => 200, :body => IO.read("spec/fixtures/request.json"), :headers => {})

       position = FactoryGirl.create :position
       position.issue_id = "8fmht6g1470b3qk8pthg"
       position.save
       
       expect(Position.first.find_detailed_status).not_to be_nil
       expect(Position.first.find_detailed_status).to eq("RECEIVED")
  end


end
