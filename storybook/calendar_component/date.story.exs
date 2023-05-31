defmodule Storybook.CalendarComponent.Date do
  use PhoenixStorybook.Story, :component
  alias CalendarApp.Calendar.Event

  def container, do: {:div, class: "flex h-full", style: "height:160px;width:120px;"}

  def function, do: &Elixir.CalendarAppWeb.CalendarComponent.date/1

  # NOTE: Timexがるとテストのときにコンパイルが通らないのであえて標準のDateを使っている
  def variations do
    [
      %Variation{
        id: :today,
        attributes: %{
          date: Date.utc_today(),
          events: []
        }
      },
      %Variation{
        id: :beginning_of_month,
        attributes: %{
          date: Date.utc_today() |> Date.add(30) |> Date.beginning_of_month(),
          events: []
        }
      },
      %Variation{
        id: :with_events,
        attributes: %{
          date: Date.utc_today() |> Date.add(1),
          events: [
            %Event{id: 1, name: "Event1", date: Date.utc_today() |> Date.add(1)},
            %Event{id: 2, name: "Event2", date: Date.utc_today() |> Date.add(1)}
          ]
        }
      },
      %Variation{
        id: :with_events_past,
        attributes: %{
          date: Date.utc_today() |> Date.add(-1),
          events: [
            %Event{id: 3, name: "Event3", date: Date.utc_today() |> Date.add(-1)},
            %Event{id: 4, name: "Event4", date: Date.utc_today() |> Date.add(-1)}
          ]
        }
      }
    ]
  end
end
