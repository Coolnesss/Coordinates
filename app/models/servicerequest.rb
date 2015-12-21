class Servicerequest < ActiveResource::Base
  self.site = ENV['HEL_URL']
  self.element_name = "request"
  headers['api_key'] = ENV['HEL_API_KEY']
end
