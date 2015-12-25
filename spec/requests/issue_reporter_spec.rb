describe "Helsinki API" do

  before (:each) do
    findResponse = IO.read("spec/fixtures/request.json")
    sendResponse = IO.read("spec/fixtures/response.json")

    stub_request(:get, /.*requests.*/).
            with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).
            to_return(:status => 200, :body => findResponse.to_json, :headers => {})

    stub_request(:post, /.*/).
            to_return(:status => 200, :body => sendResponse.to_json, :headers => {})
  end

  describe "GET /requests/:id.json" do
    it "can fetch a resource from the API" do
      id = "bba4074833f201433c6af954eace80ccab468761"

      response = IssueReporter.find(id)

      expect(response).to include('service_request_id')
      expect(response).to include('Testipalaute. Ei tarvitse vastata.')

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
