defmodule Kierroskone.Repo do
  use Ecto.Repo,
    otp_app: :kierroskone,
    adapter: Ecto.Adapters.Postgres
end
