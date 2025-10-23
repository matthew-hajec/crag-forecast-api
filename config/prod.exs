import Config

# Production environment configuration
config :crag_forecast,
  port: String.to_integer(System.get_env("PORT") || "4000"),
  use_dev_routes: false
