defmodule KierroskoneWeb.PageController do
  use KierroskoneWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def tracks(conn, _params) do
    render(conn, "tracks.html")
  end

  def track(conn, %{"id" => trackId}) do
    render(conn, "track.html")
  end
end
