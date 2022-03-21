defmodule Kierroskone.Repo.Migrations.AddGameIdToCar do
  use Ecto.Migration

  def change do
    alter table(:cars) do
      add :game_id, references(:games, on_delete: :nothing)
    end

    create index(:cars, [:game_id])

    flush()

    # assign to first game found if any
    try do
      game_id = Kierroskone.Repo.all(Kierroskone.Games.Game) |> Enum.at(0) |> Map.get(:id)
      Kierroskone.Repo.update_all("cars", set: [game_id: game_id])
    after
      {:ok, nil}
    end
  end
end
