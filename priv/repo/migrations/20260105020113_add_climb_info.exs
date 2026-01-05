defmodule CragForecast.Repo.Migrations.AddClimbInfo do
  use Ecto.Migration

  def change do
    alter table(:crags) do
      add :count_trad, :integer, null: false
      add :count_sport, :integer, null: false
      add :count_top_rope, :integer, null: false
      add :count_boulder, :integer, null: false
    end
  end
end
