defmodule CalendarAppWeb.CalendarLive.DateComponent do
  use CalendarAppWeb, :live_component

  # attr :date, :any, required: true # type: Date
  # attr :events, :list, required: true

  def render(assigns) do
    ~H"""
    <div
      phx-click={JS.patch(~p"/events/new/#{Date.to_string(@date)}")}
      class="flex-1 border-gray-100 border-2 overflow-auto"
    >
      <.title date={@date} />
      <%= for event <- @events do %>
        <.event event={event} />
      <% end %>
    </div>
    """
  end

  # attr :date, :any, required: true # type: Date

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

  # attr :event, :any, required: true # type: Event

  defp event(assigns) do
    ~H"""
    <div
      phx-click={JS.patch(~p"/events/#{@event.id}/edit")}
      class="bg-brand text-white px-1 rounded-md my-0.5"
      style="min-height:24px;"
    >
      <%= @event.name %>
    </div>
    """
  end
end
