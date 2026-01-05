defmodule CragForecast.CragLoaders.WebCSV do
  require Logger

  alias NimbleCSV.RFC4180, as: CSV

  @behaviour CragForecast.CragLoader

  def load_crags() do
    Logger.info("Fetching crag data from web CSV...")
    start_tm = :os.system_time(:millisecond)

    url = Application.get_env(:crag_forecast, CragForecast.CragLoaders.WebCSV)[:url]

    case HTTPoison.get(url, [], follow_redirect: true) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        parsed = parse_csv(body)
        end_tm = :os.system_time(:millisecond)
        Logger.info("Fetched and parsed #{length(parsed)} crags in #{end_tm - start_tm} ms.")
        {:ok, parsed}

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
    |> Enum.map(fn row -> Enum.take(row, 9) end)
    |> Enum.map(fn [name, region, country, lat, lon, nr_trad, nr_sport, nr_tr, nr_boulder] ->
      %CragForecast.Crag{
        name: name,
        region: region,
        country: country,
        latitude: Float.parse(lat) |> elem(0),
        longitude: Float.parse(lon) |> elem(0),
        count_trad: Integer.parse(nr_trad) |> elem(0),
        count_sport: Integer.parse(nr_sport) |> elem(0),
        count_top_rope: Integer.parse(nr_tr) |> elem(0),
        count_boulder: Integer.parse(nr_boulder) |> elem(0)
      }
    end)
  end
end
