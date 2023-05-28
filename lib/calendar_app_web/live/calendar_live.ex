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
end
