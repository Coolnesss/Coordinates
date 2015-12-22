class ServiceRequest
  include Her::Model

  collection_path "requests"
  primary_key :service_request_id
  
end
