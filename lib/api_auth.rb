class ApiAuth < Faraday::Middleware
  def call(env)
    env[:request_headers]["api_key"] = ENV["HEL_API_KEY"]
    env[:request_headers]["Content-Type"] = "application/json"
    @app.call(env)
  end
end
