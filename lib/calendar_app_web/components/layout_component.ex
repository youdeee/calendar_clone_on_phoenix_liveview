defmodule CalendarAppWeb.LayoutComponent do
  use CalendarAppWeb, :html

  slot :inner_block

  def header(assigns) do
    ~H"""
    <header class="px-4 sm:px-6 lg:px-8">
      <div class="flex items-center justify-between border-b border-zinc-100 py-3 text-sm">
        <div class="flex items-center gap-4">
          <p>
            <img src={~p"/images/calendar.svg"} width="36" />
          </p>
          <p class="text-brand pr-2 font-medium leading-6">
            カレンダー
          </p>
          <%= render_slot(@inner_block) %>
        </div>
        <div class="flex items-center gap-4 font-semibold leading-6 text-zinc-900">
          <div class="w-9 h-9 rounded-full bg-brand text-white leading-6"></div>
        </div>
      </div>
    </header>
    """
  end

  # type: Date
  attr :this_month, :any, required: true

  def calendar_header(assigns) do
    assigns = assign(assigns, :prev_month, assigns.this_month |> Timex.shift(months: -1))
    assigns = assign(assigns, :next_month, assigns.this_month |> Timex.shift(months: 1))

    ~H"""
    <CalendarAppWeb.LayoutComponent.header>
      <p class="px-2 font-medium leading-6">
        <.link patch={~p"/"}>
          <button class="border-gray-200 border-2 rounded px-4 py-1">今日</button>
        </.link>
      </p>
      <p class="pl-2 font-medium leading-6">
        <.link patch={~p"/month/#{@prev_month.year}/#{@prev_month.month}"}>
          ＜
        </.link>
      </p>
      <p class="pr-2 font-medium leading-6">
        <.link patch={~p"/month/#{@next_month.year}/#{@next_month.month}"}>
          ＞
        </.link>
      </p>
      <p class="px-2 font-medium leading-6 text-xl">
        <%= @this_month.year %>年 <%= @this_month.month %>月
      </p>
    </CalendarAppWeb.LayoutComponent.header>
    """
  end
end
