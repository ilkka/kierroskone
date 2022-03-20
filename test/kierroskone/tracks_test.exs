defmodule Kierroskone.TracksTest do
  use Kierroskone.DataCase

  alias Kierroskone.Tracks

  describe "tracks" do
    alias Kierroskone.Tracks.Track

    import Kierroskone.TracksFixtures

    @invalid_attrs %{name: nil}

    test "list_tracks/0 returns all tracks" do
      track = track_fixture()
      assert Tracks.list_tracks() == [track]
    end

    test "get_track!/1 returns the track with given id" do
      track = track_fixture()
      assert Tracks.get_track!(track.id) == track
    end

    test "create_track/1 with valid data creates a track" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Track{} = track} = Tracks.create_track(valid_attrs)
      assert track.name == "some name"
    end

    test "create_track/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracks.create_track(@invalid_attrs)
    end

    test "update_track/2 with valid data updates the track" do
      track = track_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Track{} = track} = Tracks.update_track(track, update_attrs)
      assert track.name == "some updated name"
    end

    test "update_track/2 with invalid data returns error changeset" do
      track = track_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracks.update_track(track, @invalid_attrs)
      assert track == Tracks.get_track!(track.id)
    end

    test "delete_track/1 deletes the track" do
      track = track_fixture()
      assert {:ok, %Track{}} = Tracks.delete_track(track)
      assert_raise Ecto.NoResultsError, fn -> Tracks.get_track!(track.id) end
    end

    test "change_track/1 returns a track changeset" do
      track = track_fixture()
      assert %Ecto.Changeset{} = Tracks.change_track(track)
    end
  end

  describe "laptimes" do
    alias Kierroskone.Tracks.Laptime

    import Kierroskone.TracksFixtures

    @invalid_attrs %{milliseconds: nil}

    test "list_laptimes/0 returns all laptimes" do
      laptime = laptime_fixture()
      assert Tracks.list_laptimes() == [laptime]
    end

    test "get_laptime!/1 returns the laptime with given id" do
      laptime = laptime_fixture()
      assert Tracks.get_laptime!(laptime.id) == laptime
    end

    test "create_laptime/1 with valid data creates a laptime" do
      valid_attrs = %{milliseconds: 42}

      assert {:ok, %Laptime{} = laptime} = Tracks.create_laptime(valid_attrs)
      assert laptime.milliseconds == 42
    end

    test "create_laptime/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracks.create_laptime(@invalid_attrs)
    end

    test "update_laptime/2 with valid data updates the laptime" do
      laptime = laptime_fixture()
      update_attrs = %{milliseconds: 43}

      assert {:ok, %Laptime{} = laptime} = Tracks.update_laptime(laptime, update_attrs)
      assert laptime.milliseconds == 43
    end

    test "update_laptime/2 with invalid data returns error changeset" do
      laptime = laptime_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracks.update_laptime(laptime, @invalid_attrs)
      assert laptime == Tracks.get_laptime!(laptime.id)
    end

    test "delete_laptime/1 deletes the laptime" do
      laptime = laptime_fixture()
      assert {:ok, %Laptime{}} = Tracks.delete_laptime(laptime)
      assert_raise Ecto.NoResultsError, fn -> Tracks.get_laptime!(laptime.id) end
    end

    test "change_laptime/1 returns a laptime changeset" do
      laptime = laptime_fixture()
      assert %Ecto.Changeset{} = Tracks.change_laptime(laptime)
    end
  end
end
