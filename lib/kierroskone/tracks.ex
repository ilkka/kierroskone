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
    Repo.all(Track) |> Repo.preload([:game, :laptimes])
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
  def get_track!(id), do: Repo.get!(Track, id) |> Repo.preload([:game, :laptimes])

  @doc """
  Get track by name for game.
  """
  def get_track_by_name(name, game) do
    from(t in Track, where: t.name == ^name and t.game_id == ^game.id)
    |> Repo.one()
    |> Repo.preload([:game])
  end

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
  def get_laptime!(id), do: Repo.get!(Laptime, id) |> Repo.preload([:user, :track, car: [:class]])

  @doc """
  Get a laptime by ID but only if it is unclaimed
  """
  def get_unclaimed_laptime(id) do
    from(lt in Laptime,
      where: lt.id == ^id and is_nil(lt.user_id)
    )
    |> Repo.one()
    |> Repo.preload([:track, car: [:class]])
  end

  @doc """
  Get all laptimes
  """
  def get_laptimes(track) do
    from(lt in Laptime, where: lt.track_id == ^track.id, order_by: [asc: lt.milliseconds])
    |> Repo.all()
    |> Repo.preload([:user, car: [:class]])
  end

  @doc """
  Get all unclaimed laptimes sorted by when they were driven, for the past 7 days
  """
  def get_unclaimed_laptimes() do
    a_week_ago = Date.add(DateTime.now!("Europe/Helsinki"), -7)

    from(lt in Laptime,
      where:
        is_nil(lt.user_id) and
          (is_nil(lt.driven_at) or
             lt.driven_at > ^NaiveDateTime.new!(a_week_ago, ~T[00:00:00])),
      order_by: [desc: lt.driven_at]
    )
    |> Repo.all()
    |> Repo.preload([:track, car: [:class]])
  end

  @doc """
  Get fastest laptime for a track
  """
  def get_overall_record(track) do
    from(lt in Laptime,
      where: lt.track_id == ^track.id and not is_nil(lt.user_id),
      order_by: [asc: lt.milliseconds],
      limit: 1
    )
    |> Repo.one()
    |> Repo.preload([:user, car: [:class]])
  end

  @doc """
  Get fastest laptimes for track, per car.
  """
  def get_records_per_car(track) do
    ranked_laptimes =
      from lt in Laptime,
        select: %{
          id: lt.id,
          rank: over(row_number(), partition_by: lt.car_id, order_by: lt.milliseconds)
        },
        where: lt.track_id == ^track.id

    top_laptime_ids =
      from lt in subquery(ranked_laptimes),
        select: [lt.id],
        where: fragment("rank = ?", 1)

    from(lt in Laptime, where: lt.id in subquery(top_laptime_ids) and not is_nil(lt.user_id))
    |> Repo.all()
    |> Repo.preload([:user, car: [:class]])
  end

  @doc """
  Helper for getting laptimes by their reported "driven at" time, which for e.g. dirt 2
  comes from the way we upload the times. This lets us check for duplicates.
  """
  def get_laptime_by_driven_at(driven_at, track) do
    from(lt in Laptime, where: lt.driven_at == ^driven_at and lt.track_id == ^track.id)
    |> Repo.one()
    |> Repo.preload([:user, car: [:class]])
  end

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
