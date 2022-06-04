defmodule Kierroskone.Repo.Migrations.AddRaces do
  use Ecto.Migration

  def change do
    create table(:races) do
      add :game_id, references(:games, on_delete: :nilify_all)
      add :car_id, references(:cars, on_delete: :nilify_all)
      add :track_id, references(:tracks, on_delete: :nilify_all)
      timestamps()
    end

    create table(:laptime_race) do
      add :race_id, references(:races, on_delete: :delete_all)
      add :laptime_id, references(:laptimes, on_delete: :delete_all)
    end
  end
end

