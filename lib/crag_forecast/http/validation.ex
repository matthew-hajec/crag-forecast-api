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

  def parse_radius(radius, max_radius) do
    case Integer.parse(radius) do
      {radius_value, ""} when radius_value >= 0 and radius_value <= max_radius ->
        {:ok, radius_value}

      _ ->
        :error
    end
  end

  def parse_offset(offset, max_offset) do
    case Integer.parse(offset) do
      {offset_value, ""} when offset_value >= 0 and offset_value <= max_offset ->
        {:ok, offset_value}

      _ ->
        :error
    end
  end

  def parse_limit(limit, max_limit) do
    case Integer.parse(limit) do
      {limit_value, ""} when limit_value > 0 and limit_value <= max_limit ->
        {:ok, limit_value}

      _ ->
        :error
    end
  end
end
