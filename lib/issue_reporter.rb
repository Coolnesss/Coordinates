require 'rest-client'

class IssueReporter
  @url = ENV["HEL_URL"]+"requests"

  def self.get_all
    JSON.parse(RestClient.get @url)
  end

  def self.delete(pos_id)
    #RestClient.log = 'stdout'
  end

  def self.send(pos_id)
    position = Position.find(pos_id)

    resp = RestClient.post(@url+".json", {
      api_key: ENV["HEL_API_KEY"],
      service_code: 171,
      description: position.description,
      title: position.name,
      lat: position.lat,
      long: position.lon,
      email: position.email
    }, {
      content_type: :json,
      accept: :json
    })

    #first because API returns array with one item
    json = JSON.parse(eval(resp)).first
    update_position(pos_id, json)
    json
  end

  private

  def self.update_position(pos_id, json)
    position = Position.find(pos_id)
    position.issue_id = json["service_request_id"]
    p position.issue_id + " asd"
    p json["service_request_id"]
    position.save unless position.issue_id == nil
  end

  def self.find(id)
    resp = RestClient.get @url+"/#{id}.json"
    ActiveSupport::JSON.decode(resp.to_str)
  end
end
