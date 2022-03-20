defmodule Kierroskone.Cars.Car do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cars" do
    field :name, :string
    belongs_to :game, Kierroskone.Games.Game
    belongs_to :class, Kierroskone.Cars.Class, foreign_key: :car_class_id

    timestamps()
  end

  @doc false
  def changeset(car, attrs) do
    car
    |> cast(attrs, [:name, :game_id, :car_class_id])
    |> validate_required([:name])
  end
end
