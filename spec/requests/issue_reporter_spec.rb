describe "Helsinki API" do

  before (:each) do
    allResponse = IO.read("spec/fixtures/requests.json")
    findResponse = IO.read("spec/fixtures/request.json")
    sendResponse = IO.read("spec/fixtures/response.json")

    stub_request(:get, /.*requests\/.*/).
            with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
            to_return(:status => 200, :body => findResponse, :headers => {})

    stub_request(:post, /.*/).
            to_return(:status => 200, :body => sendResponse, :headers => {})

    stub_request(:get, /.*requests.json/).
            to_return(:status => 200, :body => allResponse, :headers => {})
  end

  describe "GET /requests.json" do
    it "can fetch all requests from the API" do
      response = IssueReporter.all

      expect(response).to be_a(Array)
      expect(response.first).to be_a(Hash)
      expect(response.first["service_request_id"]).to eq "bba4074833f201433c6af954eace80ccab468761"
    end
  end


  describe "GET /requests/:id.json" do
    it "can fetch a resource from the API" do
      id = "bba4074833f201433c6af954eace80ccab468761"

      response = IssueReporter.find id

      expect(response).to include('service_request_id')
      expect(response["description"]).to include('Testipalaute. Ei tarvitse vastata.')

    end
  end

  describe "POST /requests.json" do

    it "can send a valid issue report for a position" do
      position = FactoryGirl.create(:position)

      expect(IssueReporter.send(position.id)).to include('service_request_id')
    end

    it "saves the service_request_id into the database when sending" do
      position = FactoryGirl.create(:position)
      resp = IssueReporter.send(position.id)

      id = resp["service_request_id"]
      expect(Position.first.issue_id).to eq(id)
    end
  end
end
