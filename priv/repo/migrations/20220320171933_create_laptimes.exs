defmodule Kierroskone.Repo.Migrations.CreateLaptimes do
  use Ecto.Migration

  def change do
    create table(:laptimes) do
      add :milliseconds, :integer
      add :track_id, references(:tracks, on_delete: :nothing)
      add :car_id, references(:cars, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
      add :driven_at, :naive_datetime

      timestamps()
    end

    create index(:laptimes, [:track_id])
    create index(:laptimes, [:car_id])
    create index(:laptimes, [:user_id])
  end
end
