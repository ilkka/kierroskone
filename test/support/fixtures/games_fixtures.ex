defmodule Kierroskone.GamesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Kierroskone.Games` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Kierroskone.Games.create_game()

    game
  end
end
