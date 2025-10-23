import Config

# Production environment configuration
config :crag_forecast,
  port: String.to_integer(System.get_env("PORT") || "4000"),
  use_dev_routes: false,
  weather_provider: CragForecast.WeatherProviders.OpenMeteo,
  crag_loader: CragForecast.CragLoaders.WebCSV,
  crag_provider: CragForecast.CragProviders.EctoProvider,
  forecast_provider: CragForecast.ForecastProviders.DefaultProvider,
  ecto_repos: [CragForecast.Repo]

config :crag_forecast, CragForecast.CragLoaders.WebCSV,
  url:
    System.get_env("CRAG_CSV_URL") ||
      "https://docs.google.com/spreadsheets/d/e/2PACX-1vQX23tF6CLyQHv8FtCQ54MdGeTtQb-gMNgMpOE-lCiZS4uP9D-6OaswesxP4M2oZrZuJrW7PMThYEJb/pub?output=csv"

config :crag_forecast, CragForecast.Repo,
  database: ":memory:",
  pool_size: 1

# Configure production logging level
config :logger, level: :info
