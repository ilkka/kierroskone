defmodule KierroskoneWeb.TelemetryController do
  use KierroskoneWeb, :controller
  alias Kierroskone.Tracks
    
  def show(conn, %{"id" => laptime_id}) do
    case Tracks.get_telemetry(laptime_id) do
      nil -> json(conn, [])
      telemetry -> json(conn, telemetry.data)
    end
  end
end
