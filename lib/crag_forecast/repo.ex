defmodule CragForecast.Repo do
  use Ecto.Repo,
    otp_app: :crag_forecast,
    adapter: Ecto.Adapters.SQLite3
end
