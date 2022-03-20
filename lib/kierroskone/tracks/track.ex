defmodule Kierroskone.Tracks.Track do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tracks" do
    field :name, :string
    belongs_to :game, Kierroskone.Games.Game
    has_many :laptimes, Kierroskone.Tracks.Laptime, foreign_key: :track_id

    timestamps()
  end

  @doc false
  def changeset(track, attrs) do
    track
    |> cast(attrs, [:name, :game_id])
    |> validate_required([:name, :game_id])
  end
end
