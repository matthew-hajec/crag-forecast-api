defmodule CragForecast.HTTP.Handlers do
  @moduledoc """
  HTTP handlers for CragForecast application.
  """
  defp validate_params_get_forecast(%{"lat" => lat, "lon" => lon}) do
    case {Float.parse(lat), Float.parse(lon)} do
      {{lat_value, ""}, {lon_value, ""}}
      when lat_value >= -90 and
             lat_value <= 90 and
             lon_value >= -180 and
             lon_value <= 180 ->
        :ok

      _ ->
        :error
    end
  end

  def handle_get_forecast(conn, %{"lat" => lat, "lon" => lon}) do
    case validate_params_get_forecast(%{"lat" => lat, "lon" => lon}) do
      :ok ->
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
