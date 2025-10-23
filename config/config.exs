import Config

# Shared configuration for all environments
config :crag_forecast,
  # Default values that can be overridden by environment-specific configs
  port: 4000,
  use_dev_routes: false,
  weather_provider: CragForecast.WeatherProviders.OpenMeteo

# Import environment-specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
