defmodule CalendarAppWeb.CalendarLive do
  use CalendarAppWeb, :live_view

  def mount(%{"year" => year, "month" => month}, _session, socket) do
    # IO.inspect "MOUNTEDaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    this_month =
      with {year, _} <- Integer.parse("#{year}"),
           {month, _} <- Integer.parse("#{month}") do
        Timex.beginning_of_month(year, month)
      else
        _ -> now()
      end
    socket = assign(socket, create_params(this_month))
    {:ok, socket}
  end

  def mount(_params, _session, socket) do
    # IO.inspect "MOUNTEDbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"
    socket = assign(socket, create_params(now()))
    {:ok, socket}
  end

  defp create_params(this_month) do
    %{
      page_title: "#{this_month.year}年#{this_month.month}月",
      first_date: this_month |> Timex.beginning_of_week(:sat),
      events: %{},
      this_month: this_month,
      prev_month: this_month |> Timex.shift(months: -1),
      next_month: this_month |> Timex.shift(months: 1)
    }
  end

  defp now, do: Timex.today("Japan") |> Timex.beginning_of_month()

  # NOTE: 果たしてここでmountしてるのが正しいのかよくわからない
  def handle_params(params, _uri, socket) do
    # IO.inspect "HANDLEcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc"
    {:ok, socket} = mount(params, nil, socket)
    {:noreply, socket}
  end

  def handle_event("change", value, socket) do
    IO.inspect value
    IO.inspect socket
    {:ok, socket} = mount(nil, nil, socket)
    {:noreply, socket}
  end

  defp weekdays, do: ["土", "日", "月", "火", "水", "木", "金"]

  def render(assigns) do
    ~H"""
    <div id="info" class="h-full">
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
    <% date = assigns.first_date |> Timex.shift(days: col + row * 7) %>
    <CalendarApp.CalendarComponent.date
    date={date}
    events={assigns.events[date] || []}
    />
    <% end %>
    </div>
    <% end %>
    </div>
    </div>
    """
  end
end
