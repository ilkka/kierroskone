defmodule KierroskoneWeb.TrackLive.Show do
  use KierroskoneWeb, :live_view

  alias Kierroskone.Tracks

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    track = Tracks.get_track!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:track, track)
     |> assign(:record, Tracks.get_overall_record(track))}
  end

  defp page_title(:show), do: "Show Track"
  defp page_title(:edit), do: "Edit Track"
end
