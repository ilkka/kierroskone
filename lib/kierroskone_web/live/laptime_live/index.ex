defmodule KierroskoneWeb.LaptimeLive.Index do
  use KierroskoneWeb, :live_view

  alias Kierroskone.Tracks
  alias Kierroskone.Tracks.Laptime

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :laptimes, list_laptimes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Laptime")
    |> assign(:laptime, Tracks.get_laptime!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Laptime")
    |> assign(:laptime, %Laptime{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Laptimes")
    |> assign(:laptime, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    laptime = Tracks.get_laptime!(id)
    {:ok, _} = Tracks.delete_laptime(laptime)

    {:noreply, assign(socket, :laptimes, list_laptimes())}
  end

  defp list_laptimes do
    Tracks.list_laptimes()
  end
end
