defmodule KierroskoneWeb.AssettoCorsaLaptimesUploadController do
  use KierroskoneWeb, :controller
  require Logger
  alias Kierroskone.{Cars, Games, Tracks}
  alias Kierroskone.Tracks.Laptime

  def create(conn, %{"_json" => laptimes}) do
    assetto_corsa =
      case Games.get_game_by_name("Assetto Corsa") do
        nil ->
          {:ok, assetto_corsa} = Games.create_game(%{"name" => "Assetto Corsa"})
          assetto_corsa

        assetto_corsa ->
          assetto_corsa
      end

    laptimes_schema =
      %{
        "type" => "array",
        "items" => %{
          "type" => "object",
          "properties" => %{
            "Car" => %{"type" => "string"},
            "Track" => %{"type" => "string"},
            "Date" => %{"type" => "string"},
            "Time" => %{"type" => "string"},
            "Topspeed" => %{"type" => "string"},
            "Telemetry" => %{"type" => "array"}
          },
          "required" => ["Car", "Track", "Date", "Time", "Topspeed"]
        }
      }
      |> ExJsonSchema.Schema.resolve()

    case ExJsonSchema.Validator.validate(laptimes_schema, laptimes) do
      :ok ->
        for laptime <- laptimes do
          %{
            "Car" => car_name,
            "Track" => track_name,
            "Date" => date,
            "Time" => time
          } = laptime
          car =
            case Cars.get_car_by_name(car_name, assetto_corsa) do
              nil ->
                {:ok, car} = Cars.create_car(%{"name" => car_name, "game_id" => assetto_corsa.id})
                car

              car ->
                car
            end

          track =
            case Tracks.get_track_by_name(track_name, assetto_corsa) do
              nil ->
                {:ok, track} =
                  Tracks.create_track(%{"name" => track_name, "game_id" => assetto_corsa.id})

                track

              track ->
                track
            end

          if is_nil(Tracks.get_laptime_by_driven_at(date, track)) do
            # No previous laptime with same original timestamp -> good to store as new
            {:ok, dur} = Timex.Duration.parse(String.replace(time, ~r/^(.*):(.*)$/, "PT\\1M\\2S"))

            {:ok, %Laptime{id: laptime_id}} =
              Tracks.create_laptime(%{
                "milliseconds" => floor(Timex.Duration.to_milliseconds(dur)),
                "track_id" => track.id,
                "car_id" => car.id,
                "driven_at" => date
            })
            
            if Map.has_key?(laptime, "Telemetry") do
              {:ok, _} = Tracks.add_telemetry(laptime_id, %{data: Map.fetch!(laptime, "Telemetry")})
            end
          end
        end

        send_resp(conn, :no_content, "")

      {:error, messages} ->
        send_resp(conn, :bad_request, inspect(messages))
    end
  end
end
