defmodule CalendarApp.Calendar do
  @moduledoc """
  The Calendar context.
  """

  import Ecto.Query, warn: false
  alias CalendarApp.Repo

  alias CalendarApp.Calendar.Event

  def today() do
    Timex.today("Japan")
  end

  def first_date_of_calendar(date) do
    date
    |> Timex.beginning_of_month()
    |> Timex.beginning_of_week(:sat)
  end

  def beginning_of_this_month(%{"year" => year, "month" => month}) do
    with {year, _} <- Integer.parse("#{year}"),
         {month, _} <- Integer.parse("#{month}") do
      Timex.beginning_of_month(year, month)
    else
      _ -> beginning_of_this_month()
    end
  end

  def beginning_of_this_month(_params), do: beginning_of_this_month()

  def beginning_of_this_month() do
    today() |> Timex.beginning_of_month()
  end

  def list_events_from_first_date(first_date) do
    # 一回に35日分表示するので
    end_date = first_date |> Timex.shift(days: 35)

    query =
      from e in Event,
        where: e.date >= ^first_date and e.date < ^end_date,
        order_by: [desc: e.id]

    Repo.all(query)
    |> Enum.reduce(%{}, fn x, acc ->
      if Map.has_key?(acc, x.date),
        do: %{acc | x.date => [x | acc[x.date]]},
        else: Map.put(acc, x.date, [x])
    end)
  end

  @doc """
  Returns the list of events.

  ## Examples

  iex> list_events()
  [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

  iex> get_event!(123)
  %Event{}

  iex> get_event!(456)
  ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)
  def get_event(id), do: Repo.get(Event, id)

  @doc """
  Creates a event.

  ## Examples

  iex> create_event(%{field: value})
  {:ok, %Event{}}

  iex> create_event(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

  iex> update_event(event, %{field: new_value})
  {:ok, %Event{}}

  iex> update_event(event, %{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

  iex> delete_event(event)
  {:ok, %Event{}}

  iex> delete_event(event)
  {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

  iex> change_event(event)
  %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end
end
