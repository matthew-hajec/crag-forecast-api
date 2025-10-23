defmodule CragForecast.HTTP.DevHandlers do
  @weather_provider Application.compile_env(:crag_forecast, :weather_provider)
  @moduledoc """
  Development-only HTTP handlers for CragForecast application.
  """

  def handle_dev_ping(conn) do
    response = %{"message" => "pong"}

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.send_resp(200, Jason.encode!(response))
  end

  def handle_dev_weather(conn, %{"lat" => lat, "lon" => lon}) do
    case @weather_provider.get_weather_window(lat, lon) do
      {:ok, weather} ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.send_resp(200, Jason.encode!(weather))

      {:error, error_msg} ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.send_resp(500, Jason.encode!(%{"error" => error_msg}))
    end
  end
end
