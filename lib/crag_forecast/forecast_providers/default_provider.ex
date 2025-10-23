defmodule CragForecast.ForecastProviders.DefaultProvider do
  @crag_provider Application.compile_env(:crag_forecast, :crag_provider)
  @weather_provider Application.compile_env(:crag_forecast, :weather_provider)
  @moduledoc """
  Uses the configured CragProvider and WeatherProvider to implement the ForecastProvider behavior.
  """
  require Logger
  @behaviour CragForecast.ForecastProvider

  @impl true
  def get_forecasts(latitude, longitude, radius_km) do
    case @crag_provider.get_nearby_crags(latitude, longitude, radius_km) do
      {:ok, crags} ->
        {:ok, get_forecasts(crags)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp get_forecasts(crags) do
    Enum.map(crags, fn crag ->
      case @weather_provider.get_weather_window(crag.latitude, crag.longitude) do
        {:ok, weather_window} ->
          {:ok, %{crag: crag, weather_window: weather_window}}

        {:error, reason} ->
          Logger.warning("Failed to fetch weather info for: #{crag}")
          {:error, reason}
      end
    end)
    |> Enum.filter(fn
      {:ok, _} -> true
      {:error, _} -> false
    end)
    # Remove the {:ok, ...} wrapper
    |> Enum.map(fn {:ok, forecast} -> forecast end)
  end
end
