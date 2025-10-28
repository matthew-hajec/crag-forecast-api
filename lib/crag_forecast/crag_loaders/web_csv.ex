defmodule CragForecast.CragLoaders.WebCSV do
  alias NimbleCSV.RFC4180, as: CSV

  @behaviour CragForecast.CragLoader

  def load_crags() do
    url = Application.get_env(:crag_forecast, CragForecast.CragLoaders.WebCSV)[:url]

    case HTTPoison.get(url, [], follow_redirect: true) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, parse_csv(body)}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Failed to fetch CSV data. Status code: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "HTTP request failed: #{reason}"}
    end
  end

  defp parse_csv(csv_content) do
    csv_content
    |> CSV.parse_string()
    # Drop extra columns if any
    |> Enum.map(fn row -> Enum.take(row, 5) end)
    |> Enum.map(fn [name, region, country, lat, lon] ->
      %CragForecast.Crag{
        name: name,
        region: region,
        country: country,
        latitude: String.to_float(lat),
        longitude: String.to_float(lon)
      }
    end)
  end
end
