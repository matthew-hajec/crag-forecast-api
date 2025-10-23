defmodule CragForecast.CragProvider do
  @moduledoc """
  Data access module for crag information.
  """

  @doc """
  Retrieves a list of nearby crags based on the provided latitude, longitude, and radius.

  ## Parameters
    - latitude: Latitude of the reference point (float).
    - longitude: Longitude of the reference point (float).
    - radius_km: Search radius in kilometers (non-negative integer).

  ## Returns
    - `{:ok, crags}`: A tuple containing a list of nearby crags.
    - `{:error, reason}`: A tuple indicating an error occurred.
  """
  @callback get_nearby_crags(float(), float(), non_neg_integer()) ::
              {:ok, [CragForecast.Crag.t()]} | {:error, term()}
end
