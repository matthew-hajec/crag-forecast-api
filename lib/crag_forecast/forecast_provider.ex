defmodule CragForecast.ForecastProvider do
  @moduledoc """
  Data access module for forecast information.
  """

  @type forecast ::
          %{
            crag: CragForecast.Crag.t(),
            weather_window: CragForecast.WeatherProvider.weather_window()
          }

  @doc """
  Searches for crags near the specified latitude and longitude within the given radius,
  and retrieves their weather forecasts.

  ## Parameters
    - latitude: Latitude of the reference point (float).
    - longitude: Longitude of the reference point (float).
    - radius_km: Search radius in kilometers (non-negative integer).
    - offset: Offset for pagination (non-negative integer).
    - limit: Maximum number of results to return (positive integer).

  ## Returns
    - `{:ok, [forecast]}`: A tuple containing forecasts for crags in the specified area.
    - `{:error, reason}`: A tuple indicating an error occurred.
  """
  @callback get_forecasts(float(), float(), non_neg_integer(), non_neg_integer(), pos_integer()) ::
              {:ok, [forecast()]} | {:error, term()}
end
