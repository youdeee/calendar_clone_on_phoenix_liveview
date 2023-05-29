defmodule CalendarApp.Calendar.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string, default: ""
    field :date, :date

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:date, :name])
    |> validate_required([:date])
    |> validate_length(:name, max: 32)
  end
end
