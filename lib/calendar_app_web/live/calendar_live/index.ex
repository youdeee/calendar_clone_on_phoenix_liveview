defmodule CalendarAppWeb.CalendarLive.Index do
  use CalendarAppWeb, :live_view

  alias CalendarApp.Calendar
  alias CalendarApp.Calendar.Event

  def mount(_params, _session, socket) do
    socket = assign(socket, index_params(%{}))
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    with event when not is_nil(event) <- Calendar.get_event(id) do
      Calendar.delete_event(event)
    end

    this_month = socket.assigns.this_month
    {:noreply, socket |> push_patch(to: ~p"/month/#{this_month.year}/#{this_month.month}")}
  end

  def handle_event("new", %{"date" => date}, socket) do
    {:noreply, socket |> push_patch(to: ~p"/events/new/#{date}")}
  end

  def handle_event("edit", %{"id" => id}, socket) do
    {:noreply, socket |> push_patch(to: ~p"/events/#{id}/edit")}
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign(index_params(params))
  end

  defp apply_action(socket, :new, %{"date" => date}) do
    socket
    |> assign(:page_title, "イベントの追加")
    |> assign(:event, %Event{date: Date.from_iso8601!(date)})
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "イベントの編集")
    |> assign(:event, Calendar.get_event!(id))
  end

  defp apply_action(socket, _, _) do
    socket
  end

  defp index_params(params) do
    beginning_of_this_month = Calendar.beginning_of_this_month(params)
    first_date = Calendar.first_date_of_calendar(beginning_of_this_month)

    %{
      events: Calendar.list_events_from_first_date(first_date),
      page_title: "#{beginning_of_this_month.year}年#{beginning_of_this_month.month}月",
      first_date: first_date,
      this_month: beginning_of_this_month,
      prev_month: beginning_of_this_month |> Timex.shift(months: -1),
      next_month: beginning_of_this_month |> Timex.shift(months: 1),
      event: nil
    }
  end

  defp weekdays, do: ["土", "日", "月", "火", "水", "木", "金"]

  def render(assigns) do
    ~H"""
    <div class="h-full">
      <div class="flex">
        <%= for col <- weekdays() do %>
          <div class="flex-1 border-gray-100 border-2 text-center">
            <%= col %>
          </div>
        <% end %>
      </div>
      <div style="height: calc(100% - 32px)">
        <%= for row <- 0..4 do %>
          <div class="flex h-1/5">
            <%= for col <- 0..6 do %>
              <% date = @first_date |> Timex.shift(days: col + row * 7) %>
              <CalendarAppWeb.CalendarComponent.date date={date} events={@events[date] || []} />
            <% end %>
          </div>
        <% end %>
      </div>
    </div>
    <.modal
      :if={@live_action in [:new, :edit]}
      id="event_modal"
      show
      on_cancel={JS.patch(~p"/month/#{@this_month.year}/#{@this_month.month}")}
    >
      <.live_component
        module={CalendarAppWeb.CalendarLive.FormComponent}
        id={@event.id || :new}
        title={@page_title}
        action={@live_action}
        event={@event}
        patch={~p"/month/#{@this_month.year}/#{@this_month.month}"}
      />
    </.modal>
    """
  end
end
