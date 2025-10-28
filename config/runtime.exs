import Config

config :crag_forecast,
  port: String.to_integer(System.get_env("PORT") || "4000")

# If in prod, use the production crag CSV URL; otherwise, use the development one (unless overridden by env var)
default_crag_csv_url =
  if config_env() == :prod do
    "https://docs.google.com/spreadsheets/d/e/2PACX-1vQX23tF6CLyQHv8FtCQ54MdGeTtQb-gMNgMpOE-lCiZS4uP9D-6OaswesxP4M2oZrZuJrW7PMThYEJb/pub?output=csv"
  else
    "https://docs.google.com/spreadsheets/d/e/2PACX-1vQesdJZcm3BSpD3mUqkZuIx7eN7y7dGH4CspZJhFuTZQn53_PxIwccDcbcg-Gjse0Pf0rVsznr1LnFk/pub?output=csv"
  end

defp parse_allowed_origins(origins) do
  origins
  |> String.split(",", trim: true)
  |> Enum.map(&String.trim/1)
end

config :crag_forecast, CragForecast.CragLoaders.WebCSV,
  url: System.get_env("CRAG_CSV_URL") || default_crag_csv_url

config :crag_forecast, CragForecast.HTTP,
  cors_allowed_origins: parse_allowed_origins(System.get_env("CORS_ALLOWED_ORIGINS")) || ["*"]
