defmodule Kierroskone.Repo.Migrations.ChangeTelemetryToJson do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE laptimes ALTER COLUMN telemetry SET DATA TYPE jsonb USING to_json(telemetry)", "ALTER TABLE laptimes ALTER COLUMN telemetry SET DATA TYPE text"
  end
end
