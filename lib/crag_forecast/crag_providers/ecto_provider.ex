defmodule CragForecast.CragProviders.EctoProvider do
  import Ecto.Query, only: [from: 2]
  require Logger
  alias CragForecast.Crag

  @behaviour CragForecast.CragProvider

  @impl true
  def get_nearby_crags(latitude, longitude, radius_km) do
    {min_lat, max_lat, min_lon, max_lon} = geo_bounding_box(latitude, longitude, radius_km)

    # 1. Query crags within the smallest bounding box containing the circle
    query =
      from c in Crag,
      where: c.latitude >= ^min_lat and c.latitude <= ^max_lat and
             c.longitude >= ^min_lon and c.longitude <= ^max_lon

    try do
      crags = CragForecast.Repo.all(query)

      # 2. Filter the results to those within the exact radius using Haversine formula
      crags = Enum.filter(crags, fn crag ->
        haversine_distance(latitude, longitude, crag.latitude, crag.longitude) <= radius_km
      end)

      {:ok, crags}
    catch
      :error, reason ->
        Logger.warning("Error fetching crags: #{inspect(reason)}")
        {:error, :failed_to_fetch_crags}
    end
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

  defp haversine_distance(lat1, lon1, lat2, lon2) do
    r = 6371.0 # Earth's radius in kilometers

    dlat = :math.pi() * (lat2 - lat1) / 180.0
    dlon = :math.pi() * (lon2 - lon1) / 180.0

    a =
      :math.sin(dlat / 2) * :math.sin(dlat / 2) +
      :math.cos(:math.pi() * lat1 / 180.0) * :math.cos(:math.pi() * lat2 / 180.0) *
      :math.sin(dlon / 2) * :math.sin(dlon / 2)

    c = 2 * :math.atan2(:math.sqrt(a), :math.sqrt(1 - a))

    r * c
  end
end
