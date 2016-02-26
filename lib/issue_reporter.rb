require 'rest-client'

class IssueReporter
  @url = ENV["HEL_URL"]+"requests"

  def self.all
    Rails.cache.fetch("issues", expires_in: 1.day) { self.fetch_all }
  end

  def self.send(pos_id)
    position = Position.find(pos_id)

    resp = RestClient.post(@url+".json", {
      api_key: ENV["HEL_API_KEY"],
      service_code: position.deduce_service_code,
      description: create_description(position),
      title: position.name,
      lat: position.lat,
      long: position.lon,
      email: position.email,
      media_url: position.one_picture_url
    }, {
      content_type: :json,
      accept: :json
    })

    #first because API returns array with one item
    json = JSON.parse(resp).first
    update_position(pos_id, json)
    json
  end

  def self.find(id)
    return nil unless id
    resp = RestClient.get @url+"/#{id}.json"
    JSON.parse(resp).first
  end

  def self.update_position(pos_id, json)
    position = Position.find pos_id
    position.issue_id = json["service_request_id"]
    position.save unless position.issue_id == nil
  end

  private

  def self.fetch_all
    JSON.parse(RestClient.get(@url+".json", {
      params: {extensions: true}
    }))
  end

  def self.create_description(position)
    position.description << "\n tehty fillari.info:n kautta. Piste kartalla: http://fillari.info/#id=#{position.id}"
  end
end
