defmodule CragForecast.HTTP.DevHandlers do
  @weather_provider Application.compile_env(:crag_forecast, :weather_provider)
  @crag_provider Application.compile_env(:crag_forecast, :crag_provider)
  @moduledoc """
  Development-only HTTP handlers for CragForecast application.
  """

  alias CragForecast.HTTP.Validation

  def handle_ping(conn) do
    response = %{"message" => "pong"}

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(200, Jason.encode!(response))
  end

  def handle_weather(conn, %{"lat" => lat, "lon" => lon}) do
    {lat, lon} = Validation.parse_lat_lon!(%{"lat" => lat, "lon" => lon})

    case @weather_provider.get_weather_window(lat, lon) do
      {:ok, weather} ->
        conn
        |> Plug.Conn.send_resp(200, Jason.encode!(weather))

      {:error, error_msg} ->
        conn
        |> Plug.Conn.send_resp(500, Jason.encode!(%{"error" => error_msg}))
    end
  end

  def handle_get_nearby_crags(conn, %{"lat" => lat, "lon" => lon, "radius" => radius}) do
    {lat, lon} = Validation.parse_lat_lon!(%{"lat" => lat, "lon" => lon})
    radius_km = String.to_integer(radius)

    case @crag_provider.get_nearby_crags(lat, lon, radius_km) do
      {:ok, crags} ->
        conn
        |> Plug.Conn.send_resp(200, Jason.encode!(%{"crags" => crags}))

      {:error, error_msg} ->
        conn
        |> Plug.Conn.send_resp(500, Jason.encode!(%{"error" => error_msg}))
    end
  end
end
