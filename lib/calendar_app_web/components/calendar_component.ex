defmodule CalendarApp.CalendarComponent do
  use Phoenix.Component

  attr :date, :any, required: true # type: Date
  attr :events, :list, required: true

  def date(assigns) do
    ~H"""
    <div class="flex-1 border-gray-100 border-2">
    <.title date={@date} />
    </div>
    """
  end

  attr :date, :any, required: true # type: Date

  defp title(assigns) do
    date = assigns.date
    title =
    if Timex.compare(date, Timex.beginning_of_month(date)) == 0 do
      "#{date.month}月 #{date.day}日"
    else
      date.day
    end

    color = if Timex.compare(date, Timex.today("Japan")) == 0 do
      "rounded-full bg-brand text-center text-white px-2"
    else
      ""
    end

    assigns = assign(assigns, title: title, color: color)

    ~H"""
    <div class="flex justify-center py-1">
    <div class={@color} style="min-width:24px; height:24px">
    <%= @title %>
    </div>
    </div>
    """
  end
end
