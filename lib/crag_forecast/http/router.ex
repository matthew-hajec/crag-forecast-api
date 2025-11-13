defmodule CragForecast.HTTP.Router do
  @use_dev_routes Application.compile_env(:crag_forecast, :use_dev_routes)

  use Plug.Router

  plug(:json_content_type)
  plug(:cors_headers)
  plug(:cache_control_header)
  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  defp json_content_type(conn, _opts) do
    Plug.Conn.put_resp_content_type(conn, "application/json")
  end

  defp cors_headers(conn, _opts) do
    allowed_origins =
      Application.get_env(:crag_forecast, CragForecast.HTTP)[:cors_allowed_origins]

    request_origin = Plug.Conn.get_req_header(conn, "origin") |> List.first()

    if request_origin in allowed_origins do
      conn
      |> Plug.Conn.put_resp_header("Access-Control-Allow-Origin", request_origin)
    else
      conn
      |> Plug.Conn.put_resp_header("Access-Control-Allow-Origin", List.first(allowed_origins))
    end
  end

  def cache_control_header(conn, _opts) do
    ttl_seconds = Application.get_env(:crag_forecast, CragForecast.HTTP)[:response_cache_ttl_seconds]
    Plug.Conn.put_resp_header(conn, "cache-control", "public, max-age=#{ttl_seconds}")
  end

  get "/forecast/:lat/:lon/:radius/:offset/:limit" do
    CragForecast.HTTP.Handlers.handle_get_forecast(conn, %{
      "lat" => lat,
      "lon" => lon,
      "radius" => radius,
      "offset" => offset,
      "limit" => limit
    })
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
