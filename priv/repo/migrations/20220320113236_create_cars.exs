defmodule Kierroskone.Repo.Migrations.CreateCars do
  use Ecto.Migration

  def change do
    create table(:cars) do
      add :name, :string
      add :class_id, references(:classes, on_delete: :nothing)

      timestamps()
    end

    create index(:cars, [:class_id])
  end
end
