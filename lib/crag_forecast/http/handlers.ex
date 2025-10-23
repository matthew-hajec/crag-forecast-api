defmodule CragForecast.HTTP.Handlers do
  @moduledoc """
  HTTP handlers for CragForecast application.
  """
  alias CragForecast.HTTP.Validation

  def handle_get_forecast(conn, %{"lat" => lat, "lon" => lon}) do
    case Validation.parse_lat_lon(%{"lat" => lat, "lon" => lon}) do
      {:ok, lat, lon} ->
        response = %{
          "latitude" => lat,
          "longitude" => lon,
          "forecast" => "Sunny with a chance of rainbows"
        }

        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.send_resp(200, Jason.encode!(response))

      :error ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.send_resp(400, "{\"error\": \"Invalid latitude or longitude\"}")
    end
  end

  def handle_not_found(conn) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(404, "{\"error\": \"Not Found\"}")
  end
end
