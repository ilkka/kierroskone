defmodule Kierroskone.Tracks.Telemetry do
  use Ecto.Schema
  import Ecto.Changeset
  
  schema "telemetry" do
    field :data, {:array, :map}
    belongs_to :laptime, Kierroskone.Tracks.Laptime
    timestamps()
  end
  
  def changeset(telemetry, attrs) do
    telemetry
    |> cast(attrs, [:data, :laptime_id])
    |> validate_required([:data, :laptime_id])
  end
end
