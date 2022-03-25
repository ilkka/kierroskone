defmodule KierroskoneWeb.PageController do
  use KierroskoneWeb, :controller
  alias Kierroskone.Tracks

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def tracks(conn, _params) do
    conn
    |> assign(
      :tracks,
      Tracks.list_tracks() |> Enum.map(fn t -> {t, Tracks.get_overall_record(t)} end)
    )
    |> render("tracks.html")
  end

  def track(conn, %{"id" => trackId}) do
    track = Tracks.get_track!(trackId)

    conn
    |> assign(:track, track)
    |> assign(:laptimes, Tracks.get_laptimes(track))
    |> assign(:record, Tracks.get_overall_record(track))
    |> assign(:records, Tracks.get_records_per_car(track))
    |> render("track.html")
  end
end
