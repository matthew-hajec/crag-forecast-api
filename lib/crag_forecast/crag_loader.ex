defmodule CragForecast.CragLoader do
  @moduledoc """
  Loads crag data from the database.

  Ran once at application startup to provide crag information.
  """

  @callback load_crags() :: {:ok, [CragForecast.Crag.t()]} | {:error, term()}
end
