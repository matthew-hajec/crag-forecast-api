import Config

# Shared configuration for all environments
config :crag_forecast,
  # Default values that can be overridden by environment-specific configs
  use_dev_routes: false,
  weather_provider: CragForecast.WeatherProviders.OpenMeteo,
  crag_loader: CragForecast.CragLoaders.WebCSV,
  crag_provider: CragForecast.CragProviders.EctoProvider,
  forecast_provider: CragForecast.ForecastProviders.DefaultProvider,
  ecto_repos: [CragForecast.Repo]

config :crag_forecast, CragForecast.HTTP,
  max_radius_km: 1000,
  max_offset: 1000,
  max_limit: 20,
  cors_allowed_origins: "*"

config :crag_forecast, CragForecast.Repo,
  database: ":memory:",
  pool_size: 1

# Configure logging level
config :logger, level: :info

# Import environment-specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
