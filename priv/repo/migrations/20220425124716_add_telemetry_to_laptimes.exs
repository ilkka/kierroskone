defmodule Kierroskone.Repo.Migrations.AddTelemetryToLaptimes do
  use Ecto.Migration

  def change do
    alter table(:laptimes) do
      add :telemetry, :text
    end
  end
end
