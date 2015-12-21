require 'rails_helper'

RSpec.describe "Service Requests", :type => :request do

  describe "GET /requests" do
    it "Can get all service requests" do
      requests = Servicerequest.all
      expect(requests).not_to be_nil
      #expect(requests).to eq(json)

    end

    it "can get a single service request by id" do
      request = Servicerequest.find("8fmht6g1470b3qk8pthg")

      expect(request).not_to be_nil
      #expect(request).to eq(json)
    end
  end
end
