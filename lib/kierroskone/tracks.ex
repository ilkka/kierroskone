defmodule Kierroskone.Tracks do
  @moduledoc """
  The Tracks context.
  """

  import Ecto.Query, warn: false
  alias Kierroskone.Repo

  alias Kierroskone.Tracks.Track

  @doc """
  Returns the list of tracks.

  ## Examples

      iex> list_tracks()
      [%Track{}, ...]

  """
  def list_tracks do
    Repo.all(Track) |> Repo.preload([:game])
  end

  @doc """
  Gets a single track.

  Raises `Ecto.NoResultsError` if the Track does not exist.

  ## Examples

      iex> get_track!(123)
      %Track{}

      iex> get_track!(456)
      ** (Ecto.NoResultsError)

  """
  def get_track!(id), do: Repo.get!(Track, id) |> Repo.preload([:game])

  @doc """
  Creates a track.

  ## Examples

      iex> create_track(%{field: value})
      {:ok, %Track{}}

      iex> create_track(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_track(attrs \\ %{}) do
    %Track{}
    |> Track.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a track.

  ## Examples

      iex> update_track(track, %{field: new_value})
      {:ok, %Track{}}

      iex> update_track(track, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_track(%Track{} = track, attrs) do
    track
    |> Track.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a track.

  ## Examples

      iex> delete_track(track)
      {:ok, %Track{}}

      iex> delete_track(track)
      {:error, %Ecto.Changeset{}}

  """
  def delete_track(%Track{} = track) do
    Repo.delete(track)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking track changes.

  ## Examples

      iex> change_track(track)
      %Ecto.Changeset{data: %Track{}}

  """
  def change_track(%Track{} = track, attrs \\ %{}) do
    Track.changeset(track, attrs)
  end

  alias Kierroskone.Tracks.Laptime

  @doc """
  Returns the list of laptimes.

  ## Examples

      iex> list_laptimes()
      [%Laptime{}, ...]

  """
  def list_laptimes do
    Repo.all(Laptime)
  end

  @doc """
  Gets a single laptime.

  Raises `Ecto.NoResultsError` if the Laptime does not exist.

  ## Examples

      iex> get_laptime!(123)
      %Laptime{}

      iex> get_laptime!(456)
      ** (Ecto.NoResultsError)

  """
  def get_laptime!(id), do: Repo.get!(Laptime, id)

  @doc """
  Creates a laptime.

  ## Examples

      iex> create_laptime(%{field: value})
      {:ok, %Laptime{}}

      iex> create_laptime(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_laptime(attrs \\ %{}) do
    %Laptime{}
    |> Laptime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a laptime.

  ## Examples

      iex> update_laptime(laptime, %{field: new_value})
      {:ok, %Laptime{}}

      iex> update_laptime(laptime, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_laptime(%Laptime{} = laptime, attrs) do
    laptime
    |> Laptime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a laptime.

  ## Examples

      iex> delete_laptime(laptime)
      {:ok, %Laptime{}}

      iex> delete_laptime(laptime)
      {:error, %Ecto.Changeset{}}

  """
  def delete_laptime(%Laptime{} = laptime) do
    Repo.delete(laptime)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking laptime changes.

  ## Examples

      iex> change_laptime(laptime)
      %Ecto.Changeset{data: %Laptime{}}

  """
  def change_laptime(%Laptime{} = laptime, attrs \\ %{}) do
    Laptime.changeset(laptime, attrs)
  end
end
