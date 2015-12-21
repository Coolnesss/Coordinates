require 'rails_helper'

describe HelApi do

  before (:each) do

  end

  it "Can create a new Service Request" do
    pos = FactoryGirl.create(:position)
    HelApi::send_service_request(pos)
    id = Position.first.api_id

    expect(id).not_to be_nil
    expect(Servicerequest.find(id)).not_to be_nil
    expect(Servicerequest.find(id).email).to eq(pos.email)
  end
end
