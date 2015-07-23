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

    it "can vote" do
      FactoryGirl.create :position
      get "/positions/1/vote", {}, { "Accept" => "application/json" }

      expect(Position.first.votes).to eq(1)
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
      expect(body).to include("poikkeusreitti")

    end
  end

  describe "POST /positions" do
    it "doesnt save a position with string coordinates" do
      json = { :format => 'json',
        :position => {
          :name => "foo",
          :description => "The best place on earth",
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
          :description => "The best place on earth",
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
          :description => "The best place on earth",
          :lon => 1,
          :lat => 1,
          :email => "lol@chang.fi"
        }
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
