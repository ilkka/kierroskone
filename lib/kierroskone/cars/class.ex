defmodule Kierroskone.Cars.Class do
  use Ecto.Schema
  import Ecto.Changeset

  schema "classes" do
    field :name, :string
    belongs_to :game, Kierroskone.Games.Game

    timestamps()
  end

  @doc false
  def changeset(class, attrs) do
    class
    |> cast(attrs, [:name, :game_id])
    |> validate_required([:name])
  end
end
