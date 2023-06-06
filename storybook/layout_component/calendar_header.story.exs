defmodule Storybook.LayoutComponent.CalendarHeader do
  use PhoenixStorybook.Story, :component

  def function, do: &Elixir.CalendarAppWeb.LayoutComponent.calendar_header/1

  def variations do
    [
      %Variation{
        id: :default,
        attributes: %{
          this_month: Date.utc_today()
        }
      }
    ]
  end

  def template do
    """
    <div class="bg-white antialiased" style="min-width:400px;">
      <.lsb-variation/>
    </div>
    """
  end
end
