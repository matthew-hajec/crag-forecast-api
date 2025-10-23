defmodule CragForecast.Crag do
  use Ecto.Schema
  @derive {Jason.Encoder, only: [:id, :name, :region, :country, :latitude, :longitude]}
  schema "crags" do
    field(:name, :string)
    field(:region, :string)
    field(:country, :string)
    field(:latitude, :float)
    field(:longitude, :float)
  end
end
