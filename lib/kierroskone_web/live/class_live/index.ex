defmodule KierroskoneWeb.ClassLive.Index do
  use KierroskoneWeb, :live_view

  alias Kierroskone.Cars
  alias Kierroskone.Cars.Class

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :classes, list_classes())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Class")
    |> assign(:class, Cars.get_class!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Class")
    |> assign(:class, %Class{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Car classes")
    |> assign(:class, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    class = Cars.get_class!(id)
    {:ok, _} = Cars.delete_class(class)

    {:noreply, assign(socket, :classes, list_classes())}
  end

  defp list_classes do
    Cars.list_classes()
  end
end
