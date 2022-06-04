defmodule Kierroskone.Races do
  @moduledoc """
  The races context.
  """

  import Ecto.Query, warn: false
  alias Kierroskone.Repo

  alias Kierroskone.Cars.{Car, Class}
  alias Kierroskone.Games.Game
  alias Kierroskone.Tracks.{Laptime, Track}

  @doc """
  Return all races.

  ## Examples

      iex> list_races()
      [%Race{}, ...]

  """
  def list_races do
    Repo.all(Race)
    |> Repo.preload([:game, :track, :car, :laptimes])
  end
end
