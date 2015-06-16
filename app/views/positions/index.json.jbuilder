json.array!(@positions) do |position|
  json.extract! position, :id, :x, :y, :name, :description
  json.url position_url(position, format: :json)
end
