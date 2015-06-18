json.array!(@positions) do |position|
  json.extract! position, :id, :lon, :lat, :name, :description
  json.url position_url(position, format: :json)
end
