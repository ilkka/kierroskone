defmodule Kierroskone.Tracks.Laptime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "laptimes" do
    field :milliseconds, :integer
    field :driven_at, :string
    belongs_to :user, Kierroskone.Users.User
    belongs_to :track, Kierroskone.Tracks.Track
    belongs_to :car, Kierroskone.Cars.Car

    timestamps()
  end

  @doc false
  def changeset(laptime, attrs) do
    laptime
    |> cast(attrs, [:milliseconds, :user_id, :track_id, :car_id, :driven_at])
    |> validate_required([:milliseconds, :track_id, :car_id])
  end
end
