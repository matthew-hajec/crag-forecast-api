import Config

# Development environment configuration
config :crag_forecast,
  use_dev_routes: true

config :crag_forecast, CragForecast.CragLoaders.WebCSV,
  url:
    "https://docs.google.com/spreadsheets/d/e/2PACX-1vQesdJZcm3BSpD3mUqkZuIx7eN7y7dGH4CspZJhFuTZQn53_PxIwccDcbcg-Gjse0Pf0rVsznr1LnFk/pub?output=csv"
