describe "Positions API" do
  describe "GET /positions" do
    it "returns all the positions" do
      FactoryGirl.create :position, name: "Katajanokka"
      FactoryGirl.create :position, name: "Seurasaari"
      get "/positions", {}, { "Accept" => "application/json" }

      expect(response.status).to eq 200

      body = JSON.parse(response.body).to_s
      expect(body).to include("Katajanokka")
      expect(body).to include("Seurasaari")
    end

    it "returns a GeoJSON with type and features array" do
      get "/positions", {}, { "Accept" => "application/json" }
      expect(response.status).to eq 200

      body = JSON.parse(response.body).to_s
      expect(body).to include("FeatureCollection")
      expect(body).to include('features')

    end

    it "includes date information" do
      FactoryGirl.create :position
      get "/positions", {}, { "Accept" => "application/json" }

      body = JSON.parse(response.body).to_s
      Time.zone = 'London'
      expect(body).to include(Time.zone.now.day.to_s)
      expect(body).to include(Time.zone.now.month.to_s)
      expect(body).to include(Time.zone.now.year.to_s)
    end

    it "includes a null image information when theres no images" do
      FactoryGirl.create :position
      get "/positions", {}, { "Accept" => "application/json" }

      body = JSON.parse(response.body).to_s
      expect(body).to include('"images"=>nil')
    end

    it "includes votes" do
      FactoryGirl.create :position
      get "/positions", {}, { "Accept" => "application/json" }

      body = JSON.parse(response.body).to_s

      expect(body).to include('"votes"=>0')
    end

    it "includes updates" do
      FactoryGirl.create :position
      get "/positions", {}, { "Accept" => "application/json" }

      body = JSON.parse(response.body).to_s

      expect(body).to include('"updates"')

    end

    it "can vote" do
      FactoryGirl.create :position
      get "/positions/1/vote", {}, { "Accept" => "application/json" }

      expect(Position.first.votes).to eq(1)
    end

    it "when voting, if number of votes is over two, calls IssueReporter" do
      position = FactoryGirl.create :position
      position.votes = 3
      position.save

      allow(IssueReporter).to receive(:send).and_return("great")
      get "/positions/1/vote", {}, { "Accept" => "application/json" }

      expect(Position.first.votes).to eq(4)
      expect(IssueReporter).to have_received(:send)
      allow(IssueReporter).to receive(:send).and_call_original
    end

    it "contains detailed_status and status for positions in API" do
      stub_request(:get, /.*8fmht6g1470b3qk8pthg.json.*/).
           to_return(:status => 200, :body => IO.read("spec/fixtures/request.json"), :headers => {})

      position = FactoryGirl.create :position
      position.issue_id = "8fmht6g1470b3qk8pthg"
      position.save

      get "/positions", {}, { "Accept" => "application/json" }

      contents = JSON.parse!(body)["features"].first["properties"]

      expect(contents).to include("status")
      expect(contents).to include("detailed_status")

      expect(contents["status"]).to eq("open")
      expect(contents["detailed_status"]).to eq("RECEIVED")
    end

    it "doesn't contain fb_id or email" do
      FactoryGirl.create :position
      get "/positions", {}, { "Accept" => "application/json" }

      expect(body).not_to include("email")
      expect(body).not_to include("fb_id")
    end

    it "contains category information" do
      FactoryGirl.create :position

      get "/positions", {}, { "Accept" => "application/json" }

      expect(body).to include("category")
      expect(body).to include("Talvikunnossapito, Lumikasa väylällä")

    end

    it "has issue_id if one is in database" do

      stub_request(:get, /.*requests\/fake.json.*/).
        with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => IO.read("spec/fixtures/request.json"), :headers => {})

      position = FactoryGirl.create :position
      position.issue_id = "fake"
      position.save

      get "/positions", {}, { "Accept" => "application/json" }
      expect(body).to include('"issue_id":"fake"')
    end

    it "a visitor has a browser that supports compression" do
      ['deflate', 'gzip', 'deflate,gzip', 'gzip,deflate'].each do |compression_method|
        get '/positions', {}, {'HTTP_ACCEPT_ENCODING' => compression_method, "Accept" => "application/json" }
        expect(response.headers['Content-Encoding']).to be
      end
    end

    it "a visitor's browser does not support compression" do
      get '/positions'
      expect(response.headers['Content-Encoding']).to_not be
    end
  end

  describe "POST /positions" do
    it "doesnt save a position with string coordinates" do
      attributes = FactoryGirl.attributes_for(:position)
      attributes["lon"] = "asd"
      attributes["lat"] = "lol"

      json = { :format => 'json',
        :position => attributes
      }
      post "/positions.json", json

      expect(Position.count).to eq(0)
    end

    it "saves a position with multiple parameters" do
      attributes = FactoryGirl.attributes_for(:position)

      json = { :format => 'json',
        :position => attributes
      }
      post "/positions.json", json

      expect(Position.count).to eq(1)
    end

    it "doesnt save a position with faulty parameters" do

      json = { :format => 'json',
        :position => ""
      }
      post "/positions.json", json

      expect(Position.count).to eq(0)
    end

    it "doesn't save a posiiton without a category" do
      attributes = FactoryGirl.attributes_for :position
      attributes["category"] = nil

      json = { :format => 'json',
        :position => attributes
      }
      post "/positions.json", json

      expect(Position.count).to eq(0)

    end

    it "doesnt save a position with a too long name" do
      attributes = FactoryGirl.attributes_for(:position)
      attributes["name"] = "reallylongsuperlongamericalongname"
      json = { :format => 'json',
        :position => attributes
      }
      post "/positions.json", json

      expect(Position.count).to eq(0)
    end

    it "saves a position with a fb_id" do
      json = { :format => 'json',
        :position => FactoryGirl.attributes_for(:position)
      }
      post "/positions.json", json

      expect(Position.count).to eq(1)
      expect(Position.first.fb_id).not_to be_nil
    end

    it "saves a position with a category" do
      json = { :format => 'json',
        :position => FactoryGirl.attributes_for(:position)
      }
      post "/positions.json", json

      expect(Position.count).to eq(1)
      expect(Position.first.category).not_to be_nil
    end
  end
  describe "DELETE /positions" do

    before (:each) do
      @position = FactoryGirl.create :position
      FactoryGirl.create :user
    end

    it "cannot destroy position without auth" do
      delete "/positions/1"

      expect(Position.count).to eq(1)
    end
  end
end
