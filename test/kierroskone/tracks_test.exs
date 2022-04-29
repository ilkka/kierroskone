defmodule Kierroskone.TracksTest do
  use Kierroskone.DataCase

  alias Kierroskone.Tracks

  describe "tracks" do
    alias Kierroskone.Tracks.Track

    import Kierroskone.TracksFixtures
    import Kierroskone.GamesFixtures

    @invalid_attrs %{name: nil}

    test "list_tracks/0 returns all tracks" do
      game = game_fixture()
      track = track_fixture(%{game_id: game.id})
      assert Tracks.list_tracks() == [%{track | game: game, laptimes: []}]
    end

    test "get_track!/1 returns the track with given id" do
      game = game_fixture()
      track = track_fixture(%{game_id: game.id})
      assert Tracks.get_track!(track.id) == %{track | game: game, laptimes: []}
    end

    test "create_track/1 with valid data creates a track" do
      game = game_fixture()
      valid_attrs = %{name: "some name", game_id: game.id}

      assert {:ok, %Track{} = track} = Tracks.create_track(valid_attrs)
      assert track.name == "some name"
    end

    test "create_track/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracks.create_track(@invalid_attrs)
    end

    test "update_track/2 with valid data updates the track" do
      game = game_fixture()
      track = track_fixture(%{game_id: game.id})
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Track{} = track} = Tracks.update_track(track, update_attrs)
      assert track.name == "some updated name"
    end

    test "update_track/2 with invalid data returns error changeset" do
      game = game_fixture()
      track = track_fixture(%{game_id: game.id})
      assert {:error, %Ecto.Changeset{}} = Tracks.update_track(track, @invalid_attrs)
      assert %{track | game: game, laptimes: []} == Tracks.get_track!(track.id)
    end

    test "delete_track/1 deletes the track" do
      game = game_fixture()
      track = track_fixture(%{game_id: game.id})
      assert {:ok, %Track{}} = Tracks.delete_track(track)
      assert_raise Ecto.NoResultsError, fn -> Tracks.get_track!(track.id) end
    end

    test "change_track/1 returns a track changeset" do
      game = game_fixture()
      track = track_fixture(%{game_id: game.id})
      assert %Ecto.Changeset{} = Tracks.change_track(track)
    end
  end

  describe "laptimes" do
    alias Kierroskone.Tracks.Laptime

    import Kierroskone.TracksFixtures
    import Kierroskone.GamesFixtures
    import Kierroskone.CarsFixtures

    @invalid_attrs %{milliseconds: nil}

    test "list_laptimes/0 returns all laptimes" do
      game = game_fixture()
      track = track_fixture(%{game_id: game.id})
      car = car_fixture(%{game_id: game.id})
      laptime = laptime_fixture(%{track_id: track.id, game_id: game.id, car_id: car.id})
      assert Tracks.list_laptimes() == [laptime]
    end

    test "get_laptime!/1 returns the laptime with given id" do
      game = game_fixture()
      track = track_fixture(%{game_id: game.id})
      car = car_fixture(%{game_id: game.id})
      laptime = laptime_fixture(%{track_id: track.id, game_id: game.id, car_id: car.id})

      assert Tracks.get_laptime!(laptime.id) == %{
               laptime
               | car: %{car | class: nil},
                 track: track,
                 user: nil
             }
    end

    test "create_laptime/1 with valid data creates a laptime" do
      game = game_fixture()
      track = track_fixture(%{game_id: game.id})
      car = car_fixture(%{game_id: game.id})
      valid_attrs = %{milliseconds: 42, game_id: game.id, track_id: track.id, car_id: car.id}

      assert {:ok, %Laptime{} = laptime} = Tracks.create_laptime(valid_attrs)
      assert laptime.milliseconds == 42
    end

    test "create_laptime/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracks.create_laptime(@invalid_attrs)
    end

    test "update_laptime/2 with valid data updates the laptime" do
      game = game_fixture()
      track = track_fixture(%{game_id: game.id})
      car = car_fixture(%{game_id: game.id})
      laptime = laptime_fixture(%{track_id: track.id, game_id: game.id, car_id: car.id})
      update_attrs = %{milliseconds: 43}

      assert {:ok, %Laptime{} = laptime} = Tracks.update_laptime(laptime, update_attrs)
      assert laptime.milliseconds == 43
    end

    test "update_laptime/2 with invalid data returns error changeset" do
      game = game_fixture()
      track = track_fixture(%{game_id: game.id})
      car = car_fixture(%{game_id: game.id})
      laptime = laptime_fixture(%{track_id: track.id, game_id: game.id, car_id: car.id})
      assert {:error, %Ecto.Changeset{}} = Tracks.update_laptime(laptime, @invalid_attrs)

      assert %{laptime | car: %{car | class: nil}, track: track, user: nil} ==
               Tracks.get_laptime!(laptime.id)
    end

    test "delete_laptime/1 deletes the laptime" do
      game = game_fixture()
      track = track_fixture(%{game_id: game.id})
      car = car_fixture(%{game_id: game.id})
      laptime = laptime_fixture(%{track_id: track.id, game_id: game.id, car_id: car.id})
      assert {:ok, %Laptime{}} = Tracks.delete_laptime(laptime)
      assert_raise Ecto.NoResultsError, fn -> Tracks.get_laptime!(laptime.id) end
    end

    test "change_laptime/1 returns a laptime changeset" do
      game = game_fixture()
      track = track_fixture(%{game_id: game.id})
      car = car_fixture(%{game_id: game.id})
      laptime = laptime_fixture(%{track_id: track.id, game_id: game.id, car_id: car.id})
      assert %Ecto.Changeset{} = Tracks.change_laptime(laptime)
    end
  end
end
