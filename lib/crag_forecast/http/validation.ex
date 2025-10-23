defmodule CragForecast.HTTP.Validation do
  def parse_lat_lon(%{"lat" => lat, "lon" => lon}) do
    case {Float.parse(lat), Float.parse(lon)} do
      {{lat_value, ""}, {lon_value, ""}}
      when lat_value >= -90 and lat_value <= 90 and lon_value >= -180 and lon_value <= 180 ->
        {:ok, lat_value, lon_value}

      _ ->
        :error
    end
  end

  def parse_lat_lon!(params) do
    case parse_lat_lon(params) do
      {:ok, lat, lon} -> {lat, lon}
      :error -> raise ArgumentError, "Invalid latitude or longitude"
    end
  end
end
