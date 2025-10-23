defmodule CragForecast.HTTP.Router do
  @use_dev_routes Application.compile_env(:crag_forecast, :use_dev_routes)

  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  get "/forecast/:lat/:lon" do
    CragForecast.HTTP.Handlers.handle_get_forecast(conn, %{"lat" => lat, "lon" => lon})
  end

  # Development-only routes
  if @use_dev_routes do
    get "/dev/ping" do
      CragForecast.HTTP.DevHandlers.handle_dev_ping(conn)
    end

    get "/dev/weather/:lat/:lon" do
      CragForecast.HTTP.DevHandlers.handle_dev_weather(conn, %{"lat" => lat, "lon" => lon})
    end
  end

  match _ do
    CragForecast.HTTP.Handlers.handle_not_found(conn)
  end
end
