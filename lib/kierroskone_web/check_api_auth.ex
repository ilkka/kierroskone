defmodule KierroskoneWeb.CheckApiAuth do
  import Plug.Conn

  def init(opts),
    do: opts

  def call(%Plug.Conn{} = conn, _opts) do
    config = Application.fetch_env!(:kierroskone, KierroskoneWeb.Endpoint)

    case get_req_header(conn, "x-api-token") do
      [token] ->
        if token != config[:laptime_api_token] do
          raise "nope"
        end

      _ ->
        raise "double nope"
    end

    conn
  end
end
