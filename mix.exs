defmodule CragForecast.MixProject do
  use Mix.Project

  def project do
    [
      app: :crag_forecast,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {CragForecast.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bandit, "~> 1.0"},
      {:jason, "~> 1.4"},
      {:httpoison, "~> 2.2"},
      {:ecto, "~> 3.13"},
      {:ecto_sqlite3, "~> 0.22"},
      {:nimble_csv, "~> 1.3"}
    ]
  end
end
