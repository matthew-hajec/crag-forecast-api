defmodule CragForecast.WeatherProvider do
  @moduledoc """
  Provides weather forecast data for given latitude and longitude.
  """

  @type condition :: :sunny | :overcast | :rainy | :snowy | :hail | :thunderstorm

  @typedoc """
  A list of weather data points for specific dates.

  Each data point is a map containing:
    - `:date` - The date of the forecast in the format "YYYY-MM-DD" (String).
    - `:max_temperature_c` - Maximum temperature in Celsius (float).
    - `:min_temperature_c` - Minimum temperature in Celsius (float).
    - `:max_humidity_percent` - Maximum relative humidity percentage (float).
    - `:max_precipitation_probability` - Maximum precipitation probability percentage (float).
    - `:condition` - Weather condition (condition()).
  """
  @type weather_window :: [%{
          date: String.t(),
          max_temperature_c: float(),
          min_temperature_c: float(),
          max_humidity_percent: float(),
          max_precipitation_probability: float(),
          condition: condition()
        }]

  @callback get_weather_window(float(), float()) :: {:ok, weather_window()} | {:error, term()}
end
