defmodule CalendarAppWeb.CalendarLive.Index do
  use CalendarAppWeb, :live_view

  alias CalendarApp.Calendar
  alias CalendarApp.Calendar.Event

  def mount(_params, _session, socket) do
    socket = assign(socket, index_params(now()))
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    with event when not is_nil(event) <- Calendar.get_event(id) do
      Calendar.delete_event(event)
    end

    {:noreply, socket}
  end

  defp apply_action(socket, :index, %{"year" => year, "month" => month}) do
    this_month =
      with {year, _} <- Integer.parse("#{year}"),
           {month, _} <- Integer.parse("#{month}") do
        Timex.beginning_of_month(year, month)
      else
        _ -> now()
      end

    socket
    |> assign(index_params(this_month))
    |> assign(:event, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(index_params(now()))
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

  defp index_params(this_month) do
    first_date = this_month |> Timex.beginning_of_week(:sat)

    %{
      events: Calendar.list_events_from_first_date(first_date),
      page_title: "#{this_month.year}年#{this_month.month}月",
      first_date: first_date,
      this_month: this_month,
      prev_month: this_month |> Timex.shift(months: -1),
      next_month: this_month |> Timex.shift(months: 1),
      event: nil
    }
  end

  defp now, do: Timex.today("Japan") |> Timex.beginning_of_month()

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
              <CalendarApp.CalendarComponent.date date={date} events={@events[date] || []} />
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
        this_month={@this_month}
      />
    </.modal>
    """
  end
end
