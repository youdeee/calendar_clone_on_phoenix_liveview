defmodule CalendarApp.CalendarFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CalendarApp.Calendar` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        name: "some name",
        date: ~D[2023-04-27]
      })
      |> CalendarApp.Calendar.create_event()

    event
  end
end
