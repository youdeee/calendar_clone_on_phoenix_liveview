defmodule CalendarApp.CalendarTest do
  use CalendarApp.DataCase
  import Mock
  alias CalendarApp.Calendar
  alias CalendarApp.Shared

  describe "events" do
    alias CalendarApp.Calendar.Event

    import CalendarApp.CalendarFixtures

    @invalid_attrs %{name: nil, date: nil}

    test "first_date_of_calendar/1 return first date of calendar (last date of month)" do
      assert Calendar.first_date_of_calendar(~D[2023-05-31]) == ~D[2023-04-29]
    end

    test "first_date_of_calendar/1 return first date of calendar (first date of month)" do
      assert Calendar.first_date_of_calendar(~D[2023-06-01]) == ~D[2023-05-27]
    end

    test "beginning_of_this_month/1 return beginning of month (with valid params)" do
      assert Calendar.beginning_of_this_month(%{"year" => 2023, "month" => 5}) == ~D[2023-05-01]
    end

    test "beginning_of_this_month/1 return beginning of month (with any)" do
      with_mock Shared, today: fn -> ~D[2023-05-27] end do
        assert Calendar.beginning_of_this_month(nil) == ~D[2023-05-01]
      end
    end

    test "beginning_of_this_month/0 return beginning of month" do
      with_mock Shared, today: fn -> ~D[2023-05-27] end do
        assert Calendar.beginning_of_this_month() == ~D[2023-05-01]
      end
    end

    test "list_events_from_first_date/1 returns events at 1 month" do
      first_date = Calendar.first_date_of_calendar(~D[2023-05-31])
      _event1 = event_fixture(name: "not within range", date: ~D[2023-04-28])
      event2 = event_fixture(name: "within range", date: ~D[2023-04-29])
      event3 = event_fixture(name: "within range", date: ~D[2023-06-02])
      event3_2 = event_fixture(name: "within range", date: ~D[2023-06-02])
      _event4 = event_fixture(name: "not within range", date: ~D[2023-06-03])

      assert Calendar.list_events_from_first_date(first_date) == %{
               ~D[2023-04-29] => [event2],
               ~D[2023-06-02] => [event3, event3_2]
             }
    end

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
