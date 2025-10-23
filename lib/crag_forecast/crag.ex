defmodule CragForecast.Crag do
  use Ecto.Schema

  schema "crags" do
    field :name, :string
    field :region, :string
    field :country, :string
    field :latitude, :float
    field :longitude, :float
  end
end
