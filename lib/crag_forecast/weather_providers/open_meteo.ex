defmodule CragForecast.WeatherProviders.OpenMeteo do
  @behaviour CragForecast.WeatherProvider

  def form_request_url(lat, lon) do
    "https://api.open-meteo.com/v1/forecast" <>
      "?latitude=#{lat}" <>
      "&longitude=#{lon}" <>
      "&forecast_days=4" <>
      "&past_days=1" <>
      "&timezone=auto" <>
      "&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max,relative_humidity_2m_max"
  end

  def get_weather_window(lat, lon) do
    case HTTPoison.get(form_request_url(lat, lon)) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        json = Jason.decode!(body)

        iana_timezone = json["timezone"]
        dates = json["daily"]["time"]
        rh_maxes = json["daily"]["relative_humidity_2m_max"]
        t_maxes = json["daily"]["temperature_2m_max"]
        t_mins = json["daily"]["temperature_2m_min"]
        p_maxes = json["daily"]["precipitation_probability_max"]

        weather_window =
          Enum.zip([dates, t_maxes, t_mins, p_maxes, rh_maxes])
          |> Enum.map(fn {date, t_max, t_min, p_max, rh_max} ->
            %{
              "timezone" => iana_timezone,
              "date" => date,
              "max_temperature_c" => t_max,
              "min_temperature_c" => t_min,
              "max_precipitation_probability" => p_max,
              "max_humidity_percent" => rh_max,
              # Placeholder condition
              "condition" => :overcast
            }
          end)

        {:ok, weather_window}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Failed to fetch weather data. Status code: #{status_code}"}

      {:error, reason} ->
        {:error, "HTTP request failed: #{inspect(reason)}"}
    end
  end
end
