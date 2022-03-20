defmodule KierroskoneWeb.ClassLive.FormComponent do
  use KierroskoneWeb, :live_component

  alias Kierroskone.Cars

  @impl true
  def mount(socket) do
    {:ok, assign(socket, games: Kierroskone.Games.list_games())}
  end

  @impl true
  def update(%{class: class} = assigns, socket) do
    changeset = Cars.change_class(class)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"class" => class_params}, socket) do
    changeset =
      socket.assigns.class
      |> Cars.change_class(class_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"class" => class_params}, socket) do
    save_class(socket, socket.assigns.action, class_params)
  end

  defp save_class(socket, :edit, class_params) do
    case Cars.update_class(socket.assigns.class, class_params) do
      {:ok, _class} ->
        {:noreply,
         socket
         |> put_flash(:info, "Class updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_class(socket, :new, class_params) do
    case Cars.create_class(class_params) do
      {:ok, _class} ->
        {:noreply,
         socket
         |> put_flash(:info, "Class created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
