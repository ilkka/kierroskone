defmodule TelemetryServer do
  @moduledoc """
  Dirt Rally 2.0 telemetry server.
  """

  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, Keyword.get(opts, :port, 20_777))
  end

  def init(port) do
    :gen_udp.open(port, [:binary, active: true])
  end

  def handle_info({:udp, _socket, _address, _port, data}, socket) do
    handle_packet(data, socket)
  end

  defp handle_packet(data, socket) do
    IO.puts("UDP in: #{String.trim(data)}")
    # do something with it
    {:noreply, socket}
  end
end
