defmodule Kierroskone.Repo.Migrations.TableForTelemetry do
  use Ecto.Migration

  def change do
    create table(:telemetry) do
      add :laptime_id, references(:laptimes, on_delete: :delete_all)
      add :data, :jsonb
      timestamps()
    end
       
    create index(:telemetry, [:laptime_id])
    
    execute """
      INSERT INTO telemetry (laptime_id, data, inserted_at, updated_at)
      (SELECT id, telemetry, now(), now() FROM laptimes WHERE telemetry IS NOT NULL)
    """, """
      UPDATE laptimes
      SET laptimes.telemetry = telemetry.data
      FROM telemetry
      WHERE laptimes.id = telemetry.laptime_id
    """

    alter table(:laptimes) do
      remove :telemetry
    end
  end 
end
