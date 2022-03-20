defmodule Kierroskone.Repo.Migrations.CreateCars do
  use Ecto.Migration

  def change do
    create table(:cars) do
      add :name, :string
      add :game_id, references(:games, on_delete: :nothing)
      add :car_class_id, references(:car_classes, on_delete: :nothing)

      timestamps()
    end

    create index(:cars, [:game_id])
    create index(:cars, [:car_class_id])
  end
end
