defmodule CalendarAppWeb.CalendarComponent do
  use CalendarAppWeb, :html

  # type: Date
  attr :date, :any, required: true
  attr :events, :list, required: true

  @doc """
  Renders a date area.

  ## Examples

      <.date date={Date.utc_today} events={[%CalendarApp.Calendar.Event{}]} />
  """
  def date(assigns) do
    is_past =
      if Timex.compare(assigns.date, Timex.today("Japan")) == -1, do: "opacity-50", else: ""

    assigns = assign(assigns, :is_past, is_past)

    ~H"""
    <div
      phx-click={JS.push("new", value: %{date: @date})}
      class="flex-1 border-gray-100 border-2 overflow-auto"
      id={"date-#{@date}"}
    >
      <.title date={@date} />
      <div class={@is_past}>
        <%= for event <- @events do %>
          <.event event={event} />
        <% end %>
      </div>
    </div>
    """
  end

  # type: Date
  attr :date, :any, required: true

  defp title(assigns) do
    date = assigns.date

    title =
      if Timex.compare(date, Timex.beginning_of_month(date)) == 0 do
        "#{date.month}月 #{date.day}日"
      else
        date.day
      end

    color =
      if Timex.compare(date, Timex.today("Japan")) == 0 do
        "rounded-full bg-brand text-center text-white px-2"
      else
        ""
      end

    assigns = assign(assigns, title: title, color: color)

    ~H"""
    <div class="flex justify-center py-1">
      <div class={@color} style="min-width:24px; height:24px;">
        <%= @title %>
      </div>
    </div>
    """
  end

  # type: Event
  attr :event, :any, required: true

  defp event(assigns) do
    ~H"""
    <div
      phx-click={JS.push("edit", value: %{id: @event.id})}
      class="bg-brand text-white px-1 rounded-md my-0.5"
      style="min-height:24px;"
      id={"event-#{@event.id}"}
    >
      <%= @event.name %>
    </div>
    """
  end
end
