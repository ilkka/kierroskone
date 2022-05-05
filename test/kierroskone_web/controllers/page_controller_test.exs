defmodule KierroskoneWeb.PageControllerTest do
  use KierroskoneWeb.ConnCase
  import Kierroskone.TracksFixtures
  import Kierroskone.GamesFixtures
  import Kierroskone.CarsFixtures

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Kierroskone"
  end
  
  defp create_laptime(_) do
    game = game_fixture()
    track = track_fixture(%{game_id: game.id})
    car = car_fixture(%{game_id: game.id})
    laptime = laptime_fixture(%{track_id: track.id, game_id: game.id, car_id: car.id})
    %{laptime: laptime}
  end
  
  describe "Laptime view" do
    setup [:create_laptime]
    
    test "GET /laptimes/ID", %{conn: conn, laptime: laptime} do
      conn = get(conn, "/dead/laptimes/#{laptime.id}")
      assert html_response(conn, 200)
    end
  end
end
