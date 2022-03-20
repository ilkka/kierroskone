defmodule Kierroskone.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Kierroskone.Repo,
      # Start the Telemetry supervisor
      KierroskoneWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Kierroskone.PubSub},
      # Start the Endpoint (http/https)
      KierroskoneWeb.Endpoint
      # Start a worker by calling: Kierroskone.Worker.start_link(arg)
      # {Kierroskone.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kierroskone.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    KierroskoneWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
