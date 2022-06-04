defmodule Kierroskone.Races.Race do
  use Ecto.Schema
  import Ecto.Changeset

  schema "races" do
    field :name, :string
    has_one :game, Kierroskone.Games.Game
    has_one :track, Kierroskone.Tracks.Track
    has_one :car, Kierroskone.Cars.Car
    has_many :laptimes, {"races_laptimes", Kierroskone.Tracks.Laptime}
  end

  @doc false
  def changeset(race, attrs) do
    race
    |> cast(attrs, [:name, :game_id, :track_id, :car_id])
    |> validate_required([:name, :game_id, :track_id, :car_id])
  end
end
