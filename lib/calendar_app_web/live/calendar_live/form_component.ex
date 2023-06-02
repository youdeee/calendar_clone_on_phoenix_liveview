defmodule CalendarAppWeb.CalendarLive.FormComponent do
  use CalendarAppWeb, :live_component

  alias CalendarApp.Calendar

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="event_form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:date]} type="date" />
        <.input field={@form[:name]} type="text" />
        <:actions>
          <div :if={@action == :new}></div>
          <.button
            :if={@action == :edit}
            phx-click={JS.push("delete", value: %{id: @event.id})}
            background="bg-red-500 hover:bg-red-300"
            type="button"
          >
            削除
          </.button>
          <.button background="bg-blue-500 hover:bg-blue-300">
            登録
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{event: event} = assigns, socket) do
    changeset = Calendar.change_event(event)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"event" => event_params}, socket) do
    changeset =
      socket.assigns.event
      |> Calendar.change_event(event_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"event" => event_params}, socket) do
    save_event(socket, socket.assigns.action, event_params)
  end

  defp save_event(socket, :edit, event_params) do
    case Calendar.update_event(socket.assigns.event, event_params) do
      {:ok, _event} ->
        # notify_parent({:saved, event})

        {:noreply,
         socket
         # |> put_flash(:info, "Event updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_event(socket, :new, event_params) do
    case Calendar.create_event(event_params) do
      {:ok, _event} ->
        # notify_parent({:saved, event})

        {:noreply,
         socket
         # |> put_flash(:info, "Event created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  # defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
