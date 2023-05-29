defmodule CalendarApp.CalendarTest do
  use CalendarApp.DataCase

  alias CalendarApp.Calendar

  describe "events" do
    alias CalendarApp.Calendar.Event

    import CalendarApp.CalendarFixtures

    @invalid_attrs %{name: nil, date: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Calendar.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Calendar.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{name: "some name", date: ~D[2023-05-27]}

      assert {:ok, %Event{} = event} = Calendar.create_event(valid_attrs)
      assert event.name == "some name"
      assert event.date == ~D[2023-05-27]
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Calendar.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{name: "some updated name", date: ~D[2023-05-28]}

      assert {:ok, %Event{} = event} = Calendar.update_event(event, update_attrs)
      assert event.name == "some updated name"
      assert event.date == ~D[2023-05-28]
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Calendar.update_event(event, @invalid_attrs)
      assert event == Calendar.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Calendar.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Calendar.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Calendar.change_event(event)
    end
  end
end
