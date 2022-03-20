defmodule KierroskoneWeb.LaptimeLive.FormComponent do
  use KierroskoneWeb, :live_component

  alias Kierroskone.Tracks

  @impl true
  def update(%{laptime: laptime} = assigns, socket) do
    changeset = Tracks.change_laptime(laptime)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"laptime" => laptime_params}, socket) do
    changeset =
      socket.assigns.laptime
      |> Tracks.change_laptime(laptime_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"laptime" => laptime_params}, socket) do
    save_laptime(socket, socket.assigns.action, laptime_params)
  end

  defp save_laptime(socket, :edit, laptime_params) do
    case Tracks.update_laptime(socket.assigns.laptime, laptime_params) do
      {:ok, _laptime} ->
        {:noreply,
         socket
         |> put_flash(:info, "Laptime updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_laptime(socket, :new, laptime_params) do
    case Tracks.create_laptime(laptime_params) do
      {:ok, _laptime} ->
        {:noreply,
         socket
         |> put_flash(:info, "Laptime created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
