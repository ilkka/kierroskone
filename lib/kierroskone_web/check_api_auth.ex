defmodule KierroskoneWeb.CheckApiAuth do
  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{} = conn, opts) do
    case get_req_header(conn, "x-api-token") do
      [token] ->
        if token != opts[:api_token] do
          raise "nope"
        end

      _ ->
        raise "double nope"
    end

    conn
  end
end
