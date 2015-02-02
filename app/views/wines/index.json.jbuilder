json.array!(@wines) do |wine|
  json.extract! wine, :id, :producer, :vintage, :varietals, :designation
  json.url wine_url(wine, format: :json)
end
