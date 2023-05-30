defmodule Storybook.CalendarComponent.Date do
  use PhoenixStorybook.Story, :component
  alias CalendarApp.Calendar.Event

  def container, do: {:div, class: "flex h-full", style: "height:160px;width:120px;"}

  def function, do: &Elixir.CalendarAppWeb.CalendarComponent.date/1

  def variations do
    [
      %Variation{
        id: :today,
        attributes: %{
          date: Timex.today("Japan"),
          events: []
        }
      },
      %Variation{
        id: :beginning_of_month,
        attributes: %{
          date: Timex.today("Japan") |> Timex.shift(months: 1) |> Timex.beginning_of_month(),
          events: []
        }
      },
      %Variation{
        id: :with_events,
        attributes: %{
          date: Timex.today("Japan") |> Timex.shift(days: 1),
          events: [
            %Event{id: 1, name: "Event1", date: Timex.today("Japan") |> Timex.shift(days: 1)},
            %Event{id: 2, name: "Event2", date: Timex.today("Japan") |> Timex.shift(days: 1)}
          ]
        }
      },
      %Variation{
        id: :with_events_past,
        attributes: %{
          date: Timex.today("Japan") |> Timex.shift(days: -1),
          events: [
            %Event{id: 3, name: "Event3", date: Timex.today("Japan") |> Timex.shift(days: -1)},
            %Event{id: 4, name: "Event4", date: Timex.today("Japan") |> Timex.shift(days: -1)}
          ]
        }
      }
    ]
  end
end
