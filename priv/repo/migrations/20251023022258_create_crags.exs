defmodule CragForecast.Repo.Migrations.CreateCrags do
  use Ecto.Migration

  def change do
    create table(:crags) do
      add :name, :string, null: false
      add :region, :string, null: false
      add :country, :string, null: false
      add :latitude, :float, null: false
      add :longitude, :float, null: false
    end

    # Create an index to query by name
    create index(:crags, [:name])

    # Create an index to query by region
    create index(:crags, [:region])

    # Create an index to query by country
    create index(:crags, [:country])

    # Create an index to query by latitude and longitude
    create index(:crags, [:latitude, :longitude])

    # Create an index to ensure uniqueness of crag names within the same region and country
    create unique_index(:crags, [:name, :region, :country])
  end
end
