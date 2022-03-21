defmodule Kierroskone.Cars.Car do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cars" do
    field :name, :string
    belongs_to :class, Kierroskone.Cars.Class
    belongs_to :game, Kierroskone.Games.Game

    timestamps()
  end

  @doc false
  def changeset(car, attrs) do
    car
    |> cast(attrs, [:name, :class_id, :game_id])
    |> validate_required([:name, :game_id])
  end
end
