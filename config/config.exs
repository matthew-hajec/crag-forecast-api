import Config

# Shared configuration for all environments
config :crag_forecast,
  # Default values that can be overridden by environment-specific configs
  port: 4000,
  use_dev_routes: false,
  weather_provider: CragForecast.WeatherProviders.OpenMeteo,
  crag_loader: CragForecast.CragLoaders.WebCSV,
  ecto_repos: [CragForecast.Repo]

config :crag_forecast, CragForecast.CragLoaders.WebCSV,
  url: "https://docs.google.com/spreadsheets/d/e/2PACX-1vQX23tF6CLyQHv8FtCQ54MdGeTtQb-gMNgMpOE-lCiZS4uP9D-6OaswesxP4M2oZrZuJrW7PMThYEJb/pub?output=csv"

config :crag_forecast, CragForecast.Repo,
  database: ":memory:",
  pool_size: 1

# Import environment-specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
