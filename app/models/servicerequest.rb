class Servicerequest < ActiveResource::Base
  self.site = ENV['HEL_URL']
  self.element_name = "request"
end
