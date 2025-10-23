defmodule CragForecast.HTTP.Router do
  @use_dev_routes Application.compile_env(:crag_forecast, :use_dev_routes)

  use Plug.Router

  plug(:json_content_type)
  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  defp json_content_type(conn, _opts) do
    Plug.Conn.put_resp_content_type(conn, "application/json")
  end

  get "/forecast/:lat/:lon" do
    CragForecast.HTTP.Handlers.handle_get_forecast(conn, %{"lat" => lat, "lon" => lon})
  end

  # Development-only routes
  if @use_dev_routes do
    get "/dev/ping" do
      CragForecast.HTTP.DevHandlers.handle_ping(conn)
    end

    get "/dev/weather/:lat/:lon" do
      CragForecast.HTTP.DevHandlers.handle_weather(conn, %{"lat" => lat, "lon" => lon})
    end

    get "/dev/nearby_crags/:lat/:lon/:radius" do
      CragForecast.HTTP.DevHandlers.handle_get_nearby_crags(conn, %{
        "lat" => lat,
        "lon" => lon,
        "radius" => radius
      })
    end
  end

  match _ do
    CragForecast.HTTP.Handlers.handle_not_found(conn)
  end
end
