defmodule CragForecast.HTTP.Handlers do
  @forecast_provider Application.compile_env(:crag_forecast, :forecast_provider)
  @max_radius_km Application.compile_env(:crag_forecast, CragForecast.HTTP)[:max_radius_km]
  @moduledoc """
  HTTP handlers for CragForecast application.
  """
  alias CragForecast.HTTP.Validation

  def handle_get_forecast(conn, %{"lat" => lat, "lon" => lon, "radius" => radius}) do
    with {:ok, lat, lon} <- Validation.parse_lat_lon(%{"lat" => lat, "lon" => lon}),
         {:ok, radius} <- Validation.parse_radius(radius, @max_radius_km) do
      {:ok, forecasts} = @forecast_provider.get_forecasts(lat, lon, radius)

      conn
      |> Plug.Conn.send_resp(200, Jason.encode!(forecasts))
    else
      :error ->
        conn
        |> Plug.Conn.send_resp(400, "{\"error\": \"Invalid parameters.\"}")
    end
  end

  def handle_not_found(conn) do
    conn
    |> Plug.Conn.send_resp(404, "{\"error\": \"Not Found\"}")
  end
end
