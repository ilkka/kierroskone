defmodule KierroskoneWeb.PageController do
  use KierroskoneWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
