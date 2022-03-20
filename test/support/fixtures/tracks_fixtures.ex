defmodule Kierroskone.TracksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Kierroskone.Tracks` context.
  """

  @doc """
  Generate a track.
  """
  def track_fixture(attrs \\ %{}) do
    {:ok, track} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Kierroskone.Tracks.create_track()

    track
  end

  @doc """
  Generate a laptime.
  """
  def laptime_fixture(attrs \\ %{}) do
    {:ok, laptime} =
      attrs
      |> Enum.into(%{
        milliseconds: 42
      })
      |> Kierroskone.Tracks.create_laptime()

    laptime
  end
end
