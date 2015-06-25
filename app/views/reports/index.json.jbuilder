json.array!(@reports) do |report|
  json.extract! report, :id, :email, :description, :cause
  json.url report_url(report, format: :json)
end
