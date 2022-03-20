defmodule KierroskoneWeb.LaptimeLiveTest do
  use KierroskoneWeb.ConnCase

  import Phoenix.LiveViewTest
  import Kierroskone.TracksFixtures

  @create_attrs %{milliseconds: 42}
  @update_attrs %{milliseconds: 43}
  @invalid_attrs %{milliseconds: nil}

  defp create_laptime(_) do
    laptime = laptime_fixture()
    %{laptime: laptime}
  end

  describe "Index" do
    setup [:create_laptime]

    test "lists all laptimes", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.laptime_index_path(conn, :index))

      assert html =~ "Listing Laptimes"
    end

    test "saves new laptime", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.laptime_index_path(conn, :index))

      assert index_live |> element("a", "New Laptime") |> render_click() =~
               "New Laptime"

      assert_patch(index_live, Routes.laptime_index_path(conn, :new))

      assert index_live
             |> form("#laptime-form", laptime: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#laptime-form", laptime: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.laptime_index_path(conn, :index))

      assert html =~ "Laptime created successfully"
    end

    test "updates laptime in listing", %{conn: conn, laptime: laptime} do
      {:ok, index_live, _html} = live(conn, Routes.laptime_index_path(conn, :index))

      assert index_live |> element("#laptime-#{laptime.id} a", "Edit") |> render_click() =~
               "Edit Laptime"

      assert_patch(index_live, Routes.laptime_index_path(conn, :edit, laptime))

      assert index_live
             |> form("#laptime-form", laptime: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#laptime-form", laptime: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.laptime_index_path(conn, :index))

      assert html =~ "Laptime updated successfully"
    end

    test "deletes laptime in listing", %{conn: conn, laptime: laptime} do
      {:ok, index_live, _html} = live(conn, Routes.laptime_index_path(conn, :index))

      assert index_live |> element("#laptime-#{laptime.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#laptime-#{laptime.id}")
    end
  end

  describe "Show" do
    setup [:create_laptime]

    test "displays laptime", %{conn: conn, laptime: laptime} do
      {:ok, _show_live, html} = live(conn, Routes.laptime_show_path(conn, :show, laptime))

      assert html =~ "Show Laptime"
    end

    test "updates laptime within modal", %{conn: conn, laptime: laptime} do
      {:ok, show_live, _html} = live(conn, Routes.laptime_show_path(conn, :show, laptime))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Laptime"

      assert_patch(show_live, Routes.laptime_show_path(conn, :edit, laptime))

      assert show_live
             |> form("#laptime-form", laptime: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#laptime-form", laptime: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.laptime_show_path(conn, :show, laptime))

      assert html =~ "Laptime updated successfully"
    end
  end
end
