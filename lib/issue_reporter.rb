require 'rest-client'

class IssueReporter
  @url = ENV["HEL_URL"]+"requests"

  def self.get_all
    JSON.parse(RestClient.get @url)
  end


  def self.delete(pos_id)
    RestClient.log = 'stdout'
  end

  def self.send(pos_id)
    RestClient.log = 'stdout'
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

    service_request = JSON.parse(resp.to_str, object_class: OpenStruct)
    puts service_request
  end
  private

  def self.update_position

  end

  def self.find(id)
    resp = RestClient.get @url+"/#{id}.json"
    JSON.parse(resp.to_str)
  end
end
