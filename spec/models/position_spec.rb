require 'rails_helper'
require 'webmock/rspec'
include ActionDispatch::TestProcess

describe Position do

  after (:each) do
    allow(IssueReporter).to receive(:find).and_call_original
    allow(IssueReporter).to receive(:send).and_call_original
  end

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

  describe "from API" do

    before :each do
      allResponse = IO.read("spec/fixtures/requests.json")

      stub_request(:get, /.*requests.json/).
              to_return(:status => 200, :body => allResponse, :headers => {})

      position = FactoryGirl.create :position
      position.issue_id = "65ad2ae4256d1e2808ea3680117b63358be68053"
      position.save
    end

    it "finds the status" do
      expect(Position.first.find_status).to eq("open")
    end

    it "finds the detailed status" do
       expect(Position.first.find_detailed_status).to eq("RECEIVED")
    end

    it "finds the status_notes" do
      expect(Position.first.find_status_notes).to eq("Palaute vastaanotettu")
    end
  end

  it "won't call IssueReporter if position already has issue id when sending" do
    allow(IssueReporter).to receive(:find).and_return("great")
    allow(IssueReporter).to receive(:send).and_return("great")
    position = FactoryGirl.create :position

    position.issue_id = "123"
    position.save

    position.send_to_api
    expect(IssueReporter).not_to have_received(:send)
  end

  it "won't call IssueReporter if position has no issue_id when searching for status" do
    allow(IssueReporter).to receive(:find).and_return("great")

    position = FactoryGirl.create :position
    position.find_status
    position.find_detailed_status

    expect(IssueReporter).not_to have_received(:find)
  end

  it "in_helsinki? returns true for a position in Helsinki" do
    pos = FactoryGirl.create :position
    expect pos.in_helsinki?
  end

  it "IssueReporter is not called if position is not in Helsinki" do
    espoo_lon = 24.69422815914966
    espoo_lat = 60.171243441670384
    allow(IssueReporter).to receive(:send).and_return("great")

    pos = FactoryGirl.create :position
    pos.lon = espoo_lon
    pos.lat = espoo_lat
    pos.save

    expect(pos.in_helsinki?).to be false
    pos.send_to_api
    expect(IssueReporter).not_to have_received(:send)
  end

  it "clears rails cache when sending to API" do
    allow(IssueReporter).to receive(:send).and_return("great")
    Rails.cache.write "issues", "best"
    expect(Rails.cache.read("issues")).to eq("best")

    position = FactoryGirl.create :position
    position.send_to_api

    wait_for(Rails.cache.read("issues")).to be_nil
  end
end
