defmodule Kierroskone.Repo.Migrations.CreateCarClasses do
  use Ecto.Migration

  def change do
    create table(:classes) do
      add :name, :string
      add :game_id, references(:games, on_delete: :nothing)

      timestamps()
    end

    create index(:classes, [:game_id])
  end
end
