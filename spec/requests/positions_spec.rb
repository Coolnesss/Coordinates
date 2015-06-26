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
      expect(body).to include(Date.today.day.to_s)
      expect(body).to include(Date.today.month.to_s)
      expect(body).to include(Date.today.year.to_s)
    end

    it "includes a null image information when theres no images" do
      FactoryGirl.create :position
      get "/positions", {}, { "Accept" => "application/json" }

      body = JSON.parse(response.body).to_s
      expect(body).to include('"image"=>"null"')
    end

    it "includes votes" do
      FactoryGirl.create :position
      get "/positions", {}, { "Accept" => "application/json" }

      body = JSON.parse(response.body).to_s

      expect(body).to include('"votes"=>0')
    end
  end

  describe "POST /positions" do
    it "doesnt save a position with string coordinates" do
      json = { :format => 'json',
        :position => {
          :name => "foo",
          :description => "bar",
          :lon => "asd",
          :lat => "asd",
          :email => "lol@chang.fi"
        }
      }
      post "/positions.json", json

      expect(Position.count).to eq(0)
    end

    it "saves a position with multiple parameters" do
      json = { :format => 'json',
        :position => {
          :name => "foo",
          :description => "bar",
          :lon => 123,
          :lat => 123,
          :email => "lol@chang.fi"
        }
      }
      post "/positions.json", json

      expect(Position.count).to eq(1)
      expect(Position.first.lon).to eq(123)
    end

    it "doesnt save a position with faulty parameters" do
      json = { :format => 'json',
        :america => {
          :bad => "foo"
        }
      }
      post "/positions.json", json

      expect(Position.count).to eq(0)
    end

    it "doesnt save a position with a too long name" do
      json = { :format => 'json',
        :position => {
          :name => "reallylongsuperlongamericalongname",
          :description => "s",
          :lon => 1,
          :lat => 1,
          :email => "lol@chang.fi"
        }
      }
      post "/positions.json", json

      expect(Position.count).to eq(0)
    end

    it "saves a position with a picture" do
      #TODO
    end
  end
end