defmodule KierroskoneWeb.Dirt2LaptimesUploadControllerTest do
  use KierroskoneWeb.ConnCase

  test "upload without telemetry", %{conn: conn} do
    conn =
      conn
      |> put_req_header("x-api-token", "laptime-test-token")
      |> put_req_header("content-type", "application/json")
      |> post("/api/laptime-import/dirt2", File.read!("test/data/req-without-telemetry.json"))

    assert response(conn, 204)
  end

  test "upload with telemetry", %{conn: conn} do
    conn =
      conn
      |> put_req_header("x-api-token", "laptime-test-token")
      |> put_req_header("content-type", "application/json")
      |> post("/api/laptime-import/dirt2", File.read!("test/data/req-with-telemetry.json"))

    assert response(conn, 204)
  end
end
