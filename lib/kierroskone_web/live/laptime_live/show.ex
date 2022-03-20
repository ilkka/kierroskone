defmodule KierroskoneWeb.LaptimeLive.Show do
  use KierroskoneWeb, :live_view

  alias Kierroskone.Tracks

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:laptime, Tracks.get_laptime!(id))}
  end

  defp page_title(:show), do: "Show Laptime"
  defp page_title(:edit), do: "Edit Laptime"
end
