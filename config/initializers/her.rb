Her::API.setup url: ENV["HEL_URL"] do |c|
  # Request
  c.use Faraday::Request::UrlEncoded

  # Response
  #c.use CustomParser
  c.use Her::Middleware::DefaultParseJSON

  # Adapter
  c.use Faraday::Adapter::NetHttp
end
