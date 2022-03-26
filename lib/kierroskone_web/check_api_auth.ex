defmodule KierroskoneWeb.CheckApiAuth do
  import Plug.Conn

  def init(opts),
    do: opts

  def call(%Plug.Conn{} = conn, opts) do
    %{"laptime_api_token" => api_token} =
      Application.fetch_env!(:kierroskone, KierroskoneWeb.Endpoint)

    case get_req_header(conn, "x-api-token") do
      [token] ->
        if token != api_token do
          raise "nope"
        end

      _ ->
        raise "double nope"
    end

    conn
  end
end
