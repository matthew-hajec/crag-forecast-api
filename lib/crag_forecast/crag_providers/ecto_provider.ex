defmodule CragForecast.CragProviders.EctoProvider do
  @behaviour CragForecast.CragProvider

  @impl true
  def get_nearby_crags(latitude, longitude, radius_km) do
    {min_lat, max_lat, min_lon, max_lon} = geo_bounding_box(latitude, longitude, radius_km)

    IO.inspect({min_lat, max_lat, min_lon, max_lon}, label: "Bounding Box")
  end

  defp geo_bounding_box(latitude, longitude, radius_km) do
    # Earth's radius in kilometers (approximate)
    km_per_degree_lat = 111.32

    # Convert latitude to radians for longitude calculation
    lat_rad = :math.pi() * latitude / 180.0

    # Calculate kilometers per degree longitude at the given latitude
    km_per_degree_lon = 111.32 * :math.cos(lat_rad)

    lat_delta = radius_km / km_per_degree_lat
    lon_delta = radius_km / km_per_degree_lon

    {
      latitude - lat_delta, # min latitude
      latitude + lat_delta, # max latitude
      longitude - lon_delta, # min longitude
      longitude + lon_delta  # max longitude
    }
  end

  # defp haversine_distance(lat1, lon1, lat2, lon2) do
  #   # Haversine formula to calculate distance between two lat/lon points
  # end
end
