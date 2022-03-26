defmodule KierroskoneWeb.PageController do
  use KierroskoneWeb, :controller
  alias Kierroskone.{Tracks, Users}
  require Logger

  def index(conn, _params) do
    render(conn, "index.html")
  end

  @doc """
  View a list of known tracks.
  """
  def tracks(conn, _params) do
    conn
    |> assign(
      :tracks,
      Tracks.list_tracks() |> Enum.map(fn t -> {t, Tracks.get_overall_record(t)} end)
    )
    |> render("tracks.html")
  end

  @doc """
  View a single track.
  """
  def track(conn, %{"id" => trackId}) do
    track = Tracks.get_track!(trackId)

    conn
    |> assign(:track, track)
    |> assign(:laptimes, Tracks.get_laptimes(track))
    |> assign(:record, Tracks.get_overall_record(track))
    |> assign(:records, Tracks.get_records_per_car(track))
    |> render("track.html")
  end

  @doc """
  Claim a laptime.
  """
  def claim(conn, %{"id" => laptimeId}) do
    case Tracks.get_unclaimed_laptime(laptimeId) do
      nil ->
        send_resp(conn, :not_found, "Laptime not found or already claimed")

      laptime ->
        case get_logged_in_user_name(conn) do
          nil ->
            send_resp(conn, :forbidden, "Not authenticated")

          user ->
            conn |> assign(:laptime, laptime) |> assign(:name, user) |> render("claim.html")
        end
    end
  end

  @doc """
  Store claim on laptime.
  """
  def submit_claim(conn, %{"id" => laptimeId}) do
    case Tracks.get_unclaimed_laptime(laptimeId) do
      nil ->
        send_resp(conn, :not_found, "Laptime not found or already claimed")

      laptime ->
        case get_logged_in_user_name(conn) do
          nil ->
            send_resp(conn, :forbidden, "Not authenticated")

          user_name ->
            {:ok, user} = Users.get_user_by_name_or_create(user_name)
            {:ok, _} = Tracks.update_laptime(laptime, %{"user_id" => user.id})
            redirect(conn, to: Routes.page_path(conn, :track, laptime.track.id))
        end
    end
  end

  @doc """
  List unclaimed laptimes
  """
  def unclaimed(conn, _params) do
    conn
    |> assign(:laptimes, Tracks.get_unclaimed_laptimes())
    |> render("unclaimed.html")
  end

  # Helper for getting the logged in user's name (or faking it for dev).
  defp get_logged_in_user_name(conn) do
    case get_req_header(conn, "oidc-data") do
      [token] ->
        %JOSE.JWT{fields: %{"name" => name}} = JOSE.JWT.peek_payload(token)
        name

      _ ->
        # dev time backdoor: static "John Doe" token
        if Mix.env() == :dev do
          %JOSE.JWT{fields: %{"name" => name}} =
            JOSE.JWT.peek_payload(
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
            )

          name
        else
          nil
        end
    end
  end
end
