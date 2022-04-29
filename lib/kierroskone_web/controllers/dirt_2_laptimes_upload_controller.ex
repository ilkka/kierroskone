defmodule KierroskoneWeb.Dirt2LaptimesUploadController do
  use KierroskoneWeb, :controller
  require Logger
  alias Kierroskone.{Cars, Games, Tracks}

  @laptimes_schema %{
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

  defp get_or_create_game() do
    case Games.get_game_by_name("Dirt Rally 2.0") do
      nil ->
        {:ok, dirt} = Games.create_game(%{"name" => "Dirt Rally 2.0"})
        dirt

      dirt ->
        dirt
    end
  end

  defp get_or_create_car(car_name, game) do
    case Cars.get_car_by_name(car_name, game) do
      nil ->
        {:ok, car} = Cars.create_car(%{"name" => car_name, "game_id" => game.id})
        car

      car ->
        car
    end
  end

  defp get_or_create_track(track_name, game) do
    case Tracks.get_track_by_name(track_name, game) do
      nil ->
        {:ok, track} = Tracks.create_track(%{"name" => track_name, "game_id" => game.id})
        track

      track ->
        track
    end
  end

  def create(conn, %{"_json" => laptimes}) do
    dirt = get_or_create_game()

    case ExJsonSchema.Validator.validate(@laptimes_schema, laptimes) do
      :ok ->
        for %{
              "Car" => car_name,
              "Track" => track_name,
              "Date" => date,
              "Time" => time,
              "Topspeed" => _topspeed,
              "Telemetry" => telemetry
            } <- laptimes do
          car = get_or_create_car(car_name, dirt)

          track = get_or_create_track(track_name, dirt)

          if is_nil(Tracks.get_laptime_by_driven_at(date, track)) do
            # No previous laptime with same original timestamp -> good to store as new
            {:ok, dur} = Timex.Duration.parse(String.replace(time, ~r/^(.*):(.*)$/, "PT\\1M\\2S"))

            {:ok, _} =
              Tracks.create_laptime(%{
                "milliseconds" => floor(Timex.Duration.to_milliseconds(dur)),
                "track_id" => track.id,
                "car_id" => car.id,
                "driven_at" => date,
                "telemetry" => telemetry
              })
          end
        end

        send_resp(conn, :no_content, "")

      {:error, messages} ->
        send_resp(conn, :bad_request, inspect(messages))
    end
  end
end
