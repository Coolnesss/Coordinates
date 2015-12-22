class CustomParser < Faraday::Response::Middleware
  def on_complete(env)
    json = MultiJson.load(env[:body], symbolize_keys: true)
    env[:body] = {
      data: json.first,
      errors: json[:errors],
      metadata: json[:metadata]
    }
  end
end
