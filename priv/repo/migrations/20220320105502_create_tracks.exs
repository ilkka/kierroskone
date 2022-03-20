defmodule Kierroskone.Repo.Migrations.CreateTracks do
  use Ecto.Migration

  def change do
    create table(:tracks) do
      add :name, :string
      add :game_id, references(:games, on_delete: :nothing)

      timestamps()
    end

    create index(:tracks, [:game_id])
  end
end
