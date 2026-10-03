defmodule Spool.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SpoolWeb.Telemetry,
      Spool.Repo,
      {DNSCluster, query: Application.get_env(:spool, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Spool.PubSub},
      # Start a worker by calling: Spool.Worker.start_link(arg)
      # {Spool.Worker, arg},
      # Start to serve requests, typically the last entry
      SpoolWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :spool]}
    ]

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Spool.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SpoolWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
