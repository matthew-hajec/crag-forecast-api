defmodule CragForecast.Crag do
  use Ecto.Schema
  @derive {Jason.Encoder, only: [
    :id,
    :name,
    :region,
    :country,
    :latitude,
    :longitude,
    :count_trad,
    :count_sport,
    :count_top_rope,
    :count_boulder
  ]}
  schema "crags" do
    field(:name, :string)
    field(:region, :string)
    field(:country, :string)
    field(:latitude, :float)
    field(:longitude, :float)
    field(:count_trad, :integer)
    field(:count_sport, :integer)
    field(:count_top_rope, :integer)
    field(:count_boulder, :integer)
  end
end
