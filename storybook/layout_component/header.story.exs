defmodule Storybook.LayoutComponent.Header do
  use PhoenixStorybook.Story, :component

  def function, do: &Elixir.CalendarAppWeb.LayoutComponent.header/1

  def variations do
    [
      %Variation{
        id: :default
      },
      %Variation{
        id: :some_word,
        slots: ["<div>hello world</div>"]
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
