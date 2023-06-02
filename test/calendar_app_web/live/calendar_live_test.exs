defmodule CalendarAppWeb.CalendarLiveTest do
  use CalendarAppWeb.ConnCase
  import Phoenix.LiveViewTest
  import CalendarApp.CalendarFixtures
  alias CalendarApp.Shared

  @create_attrs %{name: "new name", date: ~D[2023-04-27]}
  @update_attrs %{name: "updated name", date: ~D[2023-04-30]}
  @invalid_attrs %{name: nil, date: nil}

  defp create_event(_) do
    event = event_fixture()
    %{event: event}
  end

  describe "Index" do
    setup [:create_event]

    test "show this month", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/")

      assert html =~ "2023年 #{Shared.today().month}月"
    end

    test "show selected month and lists events", %{conn: conn, event: event} do
      {:ok, _index_live, html} = live(conn, ~p"/month/2023/4")

      assert html =~ "2023年 4月"
      assert html =~ event.name
    end

    test "show this month when params is invalid", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/month/hoge/fuga")

      assert html =~ "2023年 #{Shared.today().month}月"
    end

    test "saves new event", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/month/2023/4")

      assert index_live |> element("#date-2023-04-15", "15") |> render_click() =~
               "イベントの追加"

      assert_patch(index_live, ~p"/events/new/2023-04-15")

      assert index_live
             |> form("#event_form", event: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#event_form", event: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/month/2023/4")

      html = render(index_live)
      assert html =~ "new name"
    end

    test "updates event in listing", %{conn: conn, event: event} do
      {:ok, index_live, _html} = live(conn, ~p"/month/2023/4")

      assert index_live |> element("#event-#{event.id}") |> render_click() =~
               "イベントの編集"

      assert_patch(index_live, ~p"/events/#{event.id}/edit")

      assert index_live
             |> form("#event_form", event: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#event_form", event: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/month/2023/4")

      html = render(index_live)
      assert html =~ "updated name"
    end

    test "deletes event in listing", %{conn: conn, event: event} do
      {:ok, index_live, _html} = live(conn, ~p"/month/2023/4")

      assert index_live |> element("#event-#{event.id}") |> render_click() =~
               "イベントの編集"

      assert_patch(index_live, ~p"/events/#{event.id}/edit")

      assert index_live |> element("button", "削除") |> render_click()

      assert_patch(index_live, ~p"/month/2023/4")

      refute has_element?(index_live, "#event-#{event.id}")
    end
  end
end
