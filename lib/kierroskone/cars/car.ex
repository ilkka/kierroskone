defmodule Kierroskone.Cars.Car do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cars" do
    field :name, :string
    belongs_to :class, Kierroskone.Cars.Class
    has_one :game, through: [:class, :game]

    timestamps()
  end

  @doc false
  def changeset(car, attrs) do
    car
    |> cast(attrs, [:name, :class_id])
    |> validate_required([:name])
  end
end
