defmodule KierroskoneWeb.Dirt2LaptimesUploadController do
  use KierroskoneWeb, :controller
  require Logger

  def create(conn, %{"_json" => laptimes}) do
    Logger.debug("laptimes: #{inspect(laptimes)}")

    for laptime <- laptimes do
      Logger.debug(inspect(laptime))
    end

    send_resp(conn, :no_content, "")
  end
end
