defmodule CalendarApp.Shared do
  def today() do
    Timex.today("Japan")
  end
end
