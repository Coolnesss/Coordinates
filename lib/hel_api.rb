class HelApi

  #Takes position and tries to take all fields and use them in service request.
  #In addition, saves the resulting id into database so it can be used to
  #query for the status later.
  def self.send_service_request(position)
    sr = Servicerequest.new

    sr.service_code = nil #TODO
    sr.description = position.description
    sr.title = position.name
    sr.lat = position.lat
    sr.long = position.lon
    sr.email = position.email #TODO check
    if not position.pictures.empty?
      sr.media_url = position.pictures.first
    end
    p "kek"

    response = sr.save
    position.api_id = response.service_request_id
    position.save
  end

  private
  def get_single(id)

  end
end
