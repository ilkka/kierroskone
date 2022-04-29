defmodule KierroskoneWeb.CheckApiAuth do
  import Plug.Conn

  def init(opts),
    do: opts

  def call(%Plug.Conn{} = conn, _opts) do
    config = Application.fetch_env!(:kierroskone, KierroskoneWeb.Endpoint)

    case get_req_header(conn, "x-api-token") do
      [token] ->
        if token != config[:laptime_api_token] do
          conn |> send_resp(401, "Unauthorized") |> halt
        else
          conn
        end

      _ ->
        conn |> send_resp(401, "Unauthorized") |> halt
    end
  end
end
